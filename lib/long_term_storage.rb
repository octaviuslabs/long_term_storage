require 'rubygems'
require 'aws-sdk'

# Wrap S3 uploads for maximum replacability later
module LongTermStorage
  class LongTermStorage
    attr_reader :bucket_name

    def initialize args={}
      @bucket_name = args.fetch(:bucket_name) {
        ENV['AWS_S3_BUCKET_NAME'] || raise("LongTermStorage requires a bucket_name")}
      @s3 = Aws::S3::Resource.new
    end

    def get_location args={}
      path = args.fetch(:path) { raise "Cannot url without path"}

      return {
        url: @s3.bucket(@bucket_name).object(path).public_url,
        bucket: @bucket_name,
        path: path
      }
    end

    def store args={}
      # Parse/validate input
      path = args.fetch(:path) { raise "Upload requires path" }
      contents = args.fetch(:contents) { raise "Upload requires string contents" }
      raise "Contents must be a string" unless contents.is_a?(String)
      raise "Path must be a string" unless contents.is_a?(String)

      # Upload
      upload_target = @s3.bucket(@bucket_name).object(path)
      upload_target.put(
        content_type: 'application/json',
        acl: 'authenticated-read',
        body: contents,
        server_side_encryption: :aes256
      )

      return {
        url: upload_target.public_url,
        bucket: @bucket_name,
        path: path }
    end

    def retrieve args={}
      url = args.fetch(:url, nil)

      if !url.nil?
        bucket_name, key = url_to_object url
      else
        bucket_name = args.fetch(:bucket_name, @bucket_name)
        key = args.fetch(:key) { raise "Retrieve requires url or key" }
      end

      s3_client = Aws::S3::Client.new
      s3_client.get_object(bucket: bucket_name, key: key).body.read
    end

    # We will eventually want to add policy_url to this for generating
    # temporary policy URL's consumable by client devices.

    protected
    def url_to_object url
      begin
        matches = url.match(/\/\/(.*?)\.s3\.amazonaws\.com\/(.*)/)
        if matches.nil?
          split_url = url.split '/'
          return split_url[3], URI.unescape(split_url[4..-1].join('/'))
        else
          return matches[1], URI.unescape(matches[2])
        end
      rescue
        raise "Invalid URL #{url}"
      end
    end

  end
end

require_relative 'long_term_storage/version'
