class BlobStorageService
  def initialize(storage_option)
    @storage = choose_storage(storage_option)
  end

  def upload(file_path, file_content)
    @storage.upload(file_path, file_content)
  end

  def file_url(file_path)
    @storage.file_url(file_path)
  end

  private

  def choose_storage(option)
    case option
    when 's3'
      S3Storage.new
    when 'local'
      LocalStorage.new
    when 'db'
      DatabaseStorage.new
    else
      raise ArgumentError, "Unsupported storage option: #{option}"
    end
  end
end
