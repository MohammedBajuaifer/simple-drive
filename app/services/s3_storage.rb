require_relative 'storage'
require 'uri'
require 'net/http'
require 'openssl'
require 'base64'

class S3Storage
  include Storage

  def initialize
    @access_key_id = 'AKIAXVHQP2XVUHQOAQMA'
    @secret_access_key = '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'
    @bucket_name = 'simple-drive'
    @region = 'eu-west-2'
  end

  def upload(file_path, file_content)
    uri = URI("https://#{@bucket_name}.s3.#{@region}.amazonaws.com/#{file_path}")
    request = Net::HTTP::Put.new(uri)
    request.body = file_content
    request['Content-Type'] = 'binary/octet-stream'
  
    date_stamp = Time.now.utc.strftime("%Y%m%d")
    signed_signature = sign_request(@secret_access_key, date_stamp, @region, "s3", "string_to_sign_here")
    authorization = authorization_header(@access_key_id, date_stamp, @region, "s3", signed_signature)
    
    request['Authorization'] = authorization
  
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request) }
  
  end
  def file_url(file_path)
    "https://#{@bucket_name}.s3.#{@region}.amazonaws.com/#{file_path}"
  end
  private

  def sign_request(key, date_stamp, region, service, string_to_sign)
    kDate    = OpenSSL::HMAC.digest('sha256', "AWS4" + key, date_stamp)
    kRegion  = OpenSSL::HMAC.digest('sha256', kDate, region)
    kService = OpenSSL::HMAC.digest('sha256', kRegion, service)
    kSigning = OpenSSL::HMAC.digest('sha256', kService, "aws4_request")
    signature = OpenSSL::HMAC.hexdigest('sha256', kSigning, string_to_sign)
  
    signature
  end

  def authorization_header(access_key, date_stamp, region, service, signed_signature)
    "AWS4-HMAC-SHA256 Credential=#{access_key}/#{date_stamp}/#{region}/#{service}/aws4_request, SignedHeaders=host;x-amz-date, Signature=#{signed_signature}"
  end

end
