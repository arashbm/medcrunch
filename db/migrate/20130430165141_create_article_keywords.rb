class CreateArticleKeywords < ActiveRecord::Migration
  def change
    create_table :article_keywords do |t|
      t.references :article, index: true
      t.references :keyword, index: true

      t.timestamps
    end
  end
end
