class Keyword < ActiveRecord::Base
  has_many :article_keywords
  has_many :articles, through: :article_keywords

  def save_keyword_occurrence!(ids=nil)
    articles = ids ? Article.where(id: ids) : Article
    aks=[]
    aid= article_ids
    articles.search_by_title_or_abstract(title).each do |article|
      unless aid.include?(article.id)
        aks << [id, article.id]
      end
    end
    ArticleKeyword.import [:keyword_id, :article_id], aks
  end
end
