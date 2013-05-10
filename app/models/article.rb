class Article < ActiveRecord::Base
  has_many :article_keywords
  has_many :keywords, through: :article_keywords

  def self.keyword_search(query)

    tsquery = sanitize_sql_array ["plainto_tsquery('english', ?)", query]
    rank = "ts_rank_cd( search_vector,  #{tsquery}, 34)"

    condition = "search_vector @@ #{tsquery}"

    ActiveRecord::Base.connection.select_all( "SELECT id, #{rank} AS rank FROM articles WHERE #{condition} ORDER BY rank DESC" )
  end
end
