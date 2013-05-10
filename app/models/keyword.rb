class Keyword < ActiveRecord::Base
  has_many :article_keywords
  has_many :articles, through: :article_keywords

  validates :title, uniqueness: true

  def neighbour_titles
    neighbour_keywords.map{ |a| [a[0], a[1].title]}
  end

  def neighbour_keywords
    neighbour_keyboard_ids.map { |a| [a['weight'].to_i, Keyword.find(a['keyword_id'])]}
  end

  def neighbour_keyboard_ids
    res = ActiveRecord::Base.connection.select_all <<-SQL
      SELECT count(k1.article_id) AS weight, k2.keyword_id
      FROM article_keywords k1, article_keywords k2
      WHERE k1.article_id = k2.article_id 
        AND k1.keyword_id = #{id}
        AND k2.keyword_id != k1.keyword_id
      GROUP BY k2.keyword_id
      ORDER BY weight DESC
    SQL
  end

  def list_keyword_occurrence(ids=nil)
    articles = ids ? Article.where(id: ids) : Article
    aks = []
    aid = article_ids
    Article.keyword_search(title).each do |article|
      unless aid.include?(article["id"])
        aks << [id, article["id"]]
      end
    end
    aks
  end

  def save_keyword_occurrence!(ids=nil)
    aks = list_keyword_occurrence(ids)
    ArticleKeyword.import [:keyword_id, :article_id], aks
  end
end
