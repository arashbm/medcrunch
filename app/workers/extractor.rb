class ArticleExtractorWorker
  include Sidekiq::Worker

  def perform(list_file, ids = nil)
    Keyword.all.each do |term|
      keyword = Keyword.find_by_title term
      keyword.save_keyword_occurrence!(ids)
    end
  end
end
