class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id
      t.column :search_post, 'tsvector'
      t.timestamps
    end
    add_index :microposts, [:user_id, :created_at]
    execute <<-EOS
      CREATE INDEX micropost_vector ON microposts USING gin(search_post)
    EOS

    execute <<-EOS
      CREATE TRIGGER micropost_vector_update BEFORE INSERT OR UPDATE
      ON microposts
      FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(search_post, 'pg_catalog.english', content)
    EOS
  end
end
