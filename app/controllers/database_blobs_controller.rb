class DatabaseBlobsController < ApplicationController
    def show
      db_blob = DatabaseBlob.find(params[:id])
      send_data db_blob.data, type: db_blob.content_type, disposition: 'inline'
    rescue ActiveRecord::RecordNotFound
      render json: { error: "File not found" }, status: :not_found
    end
  end