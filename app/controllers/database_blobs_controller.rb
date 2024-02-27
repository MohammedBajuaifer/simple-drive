class DatabaseBlobsController < ApplicationController
  def show
    database_blob = DatabaseBlob.find(params[:id])
    render json: {
      id: database_blob.id,
      data: database_blob.data,
      created_at: database_blob.created_at
    }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "DatabaseBlob not found" }, status: :not_found
  end
  end