class BlobsController < ApplicationController
  before_action :verify_jwt_token

  STATIC_TOKEN = 'static_token'.freeze


  def show
    blob = Blob.find(params[:id])
    metadata = blob.blob_metadata

    render json: {
      id: blob.id,
      size: blob.size,
      storage_type: metadata.storage_type,
      file_path: metadata.file_path,
      data: blob.data,
      created_at: blob.created_at
    }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Blob not found" }, status: :not_found
  end


  def create
    begin
      file_content = Base64.decode64(blob_params[:data])
    rescue ArgumentError => e
      return render json: { error: 'Invalid base64 data' }, status: :unprocessable_entity
    end
    size = file_content.bytesize
  
    storage_option = params[:storage_option] || 'local'
    storage_service = BlobStorageService.new(storage_option)
  
    if storage_option == 'db'
      db_blob_id = storage_service.upload(nil, file_content)
      if db_blob_id
      encoded_data = Base64.encode64(file_content)
      render json: { id: db_blob_id, data: encoded_data, status: :created }
      else
        render json: { error: 'Failed to upload' }, status: :unprocessable_entity
      end
    else
      blob = Blob.new(size: size, data: blob_params[:data])
      if blob.save
        file_path = "uploads/#{blob.id}"
        if storage_service.upload(file_path, file_content)
          blob.create_blob_metadata(storage_type: storage_option, file_path: file_path)
          render json: { id: blob.id, path: storage_service.file_url(file_path), size: size, status: :created }
        else
          render json: { error: 'Failed to upload' }, status: :unprocessable_entity
        end
      else
        render json: blob.errors, status: :unprocessable_entity
      end
    end
  end
  

  private

  def blob_params
    params.require(:blob).permit(:data)
  end

  def verify_jwt_token
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last if auth_header

    unless token && ActiveSupport::SecurityUtils.secure_compare(token, STATIC_TOKEN)
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
