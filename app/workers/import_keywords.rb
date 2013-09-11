require 'file_mark'
class ImportKeywordWorker
  include Sidekiq::Worker
  include FileMark

  def read_list(list_file)
    File.readlines(list_file).map(&:chomp).uniq
  end

  def perform(list_file, ids = nil)
    list = []
    with_locked_file list_file do
      keyword_list = read_list(list_file)
      keyword_list.each do |term|
        keyword = Keyword.where(title: term.to_s).first_or_create

        # search all current articles
        list.concat keyword.list_keyword_occurrence
        p "relations in this job: #{list.count}"
        p "keywords in this job: #{keyword_list.index(term)}/#{keyword_list.count}"
      end
      ArticleKeyword.import [:keyword_id, :article_id], list, validate: false, timestamps: false
    end
  end
end
