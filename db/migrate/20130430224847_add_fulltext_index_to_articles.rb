class AddFulltextIndexToArticles < ActiveRecord::Migration
  def change
    execute "
        create index on articles using gin(to_tsvector('english', title));
        create index on articles using gin(to_tsvector('english', abstract));"
  end
end
