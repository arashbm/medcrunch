class ArticleExtractorWorker
  include Sidekiq::Worker

  def perform(ids = nil)
    list = []
    Keyword.includes(:articles).find_each do |keyword|
      list.concat keyword.list_keyword_occurrence(ids)
    end
    ArticleKeyword.import [:keyword_id, :article_id], list, validate: false
  end
end
