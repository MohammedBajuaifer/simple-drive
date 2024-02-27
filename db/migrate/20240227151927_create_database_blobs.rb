class CreateDatabaseBlobs < ActiveRecord::Migration[7.1]
  def change
    create_table :database_blobs do |t|
      t.text :data
      t.integer :size

      t.timestamps
    end
  end
end
