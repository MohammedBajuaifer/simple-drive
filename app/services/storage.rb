module Storage
    def upload(file_path, file_content)
      raise NotImplementedError, "This #{self.class} cannot respond to #{__method__}"
    end
  
    def file_url(file_path)
      raise NotImplementedError, "This #{self.class} cannot respond to #{__method__}"
    end
  end