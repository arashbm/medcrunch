class CreateKeywordsRelations < ActiveRecord::Migration
  def change
    create_table :keywords_relations do |t|
      t.integer :keyword_first_id
      t.integer :weight
      t.integer :keyword_last_id

      t.timestamps
    end
  end
end
