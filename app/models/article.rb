class Article < ActiveRecord::Base
  has_many :article_keywords
  has_many :keywords, through: :article_keywords
end
