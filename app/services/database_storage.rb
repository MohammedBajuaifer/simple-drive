require_relative 'storage'

class DatabaseStorage
  include Storage

  def upload(file_path, file_content)
    encoded_data = Base64.encode64(file_content)
    db_blob = DatabaseBlob.create(data: encoded_data, size: file_content.bytesize)
    return db_blob.persisted? ? db_blob.id : nil # Ensure this returns the ID or nil
  end
  def file_url(file_path)
    
  end
end
