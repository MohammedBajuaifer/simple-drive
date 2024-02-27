require_relative 'storage'


class LocalStorage
    include Storage
  
    def initialize(base_path = Rails.root.join('storage'))
      @base_path = base_path
    end
  
    def upload(file_path, file_content)
      full_path = File.join(@base_path, file_path)
      FileUtils.mkdir_p(File.dirname(full_path))
      File.open(full_path, 'wb') { |file| file.write(file_content) }
      true
    rescue StandardError => e
      Rails.logger.error "Failed to save file locally: #{e.message}"
      false
    end
  
    def file_url(file_path)
      "/local_storage/#{file_path}"
    end
  end
  