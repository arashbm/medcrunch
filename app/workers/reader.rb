require 'file_mark'
class ArticleReaderWorker
  include Sidekiq::Worker

  include FileMark

  # it will find a file, read it, validate it and import it to database as raw
  # article data. Then mark the file as imported.
  def perform(filename)

    # checking if already imported
    if dataset_marked? filename, 'imported'
      puts "#{filename} is already imported, skipping."
      return
    end

    articles_to_import = []

    with_locked_file filename do
      puts "Opening file at #{filename}"
      file = File.open filename
      puts "creating a nokogiri document..."
      doc = Nokogiri.XML(file)

      # checking for errors in file
      if doc.errors.length > 0
        puts "error reading file #{filename}, marking 'errors'"
        mark_dataset(filename, 'errors')
        # mark the file as incomplete
        raise 'bad file'
      end

      # inserting into array
      doc.css('PubmedArticle').each do |article|
        pmid = article.css('MedlineCitation PMID').first.text.to_i
        raw_xml = article.to_s
        title = article.css('MedlineCitation Article ArticleTitle').first.try(:text)
        abstract = article.css('MedlineCitation Article Abstract AbstractText').first.try(:text)

        articles_to_import << [pmid, raw_xml, title, abstract] if pmid
      end

      # we are pretty confident about validity of data
      cols = [:pubmed_id, :raw_pubmed_xml, :title, :abstract]
      res = Article.import cols, articles_to_import, validate: false

      ids = Article.select(:id).last(articles_to_import.size).map(&:id)
      harrison_path = (Rails.root.join + 'vendor' + 'harrison_purified.txt').to_s
      ids.each_slice(50) do |slice|
        ArticleExtractorWorker.perform_async harrison_path, slice
      end

      # mark the file as imported
      unmark_dataset(filename, 'errors')
      mark_dataset(filename, 'imported')
    end
  end
end
