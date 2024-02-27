class CreateBlobMetadata < ActiveRecord::Migration[7.1]
  def change
    create_table :blob_metadata do |t|
      t.references :blob, null: false, foreign_key: true
      t.string :storage_type
      t.string :file_path

      t.timestamps
    end
  end
end
