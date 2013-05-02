class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.text :title
      t.text :abstract
      t.integer :pubmed_id
      t.text :raw_pubmed_xml

      t.timestamps
    end
  end
end
