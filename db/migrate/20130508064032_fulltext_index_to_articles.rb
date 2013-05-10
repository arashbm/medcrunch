class FulltextIndexToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :search_vector, 'tsvector'

    execute <<-SQL
      CREATE INDEX articles_search_idx ON articles USING gin(search_vector)
    SQL

    execute <<-SQL
      DROP TRIGGER IF EXISTS articles_vector_update ON articles
    SQL

    execute <<-SQL
      CREATE TRIGGER articles_vector_update BEFORE INSERT OR UPDATE
      ON articles FOR EACH ROW EXECUTE PROCEDURE
        tsvector_update_trigger(search_vector, 'pg_catalog.english', title, abstract);
    SQL
    
    Article.select(:id).find_each(batch_size: 20000){ |a| a.touch }
  end
end
