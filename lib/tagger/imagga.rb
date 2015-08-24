require_relative '../../config/environment.rb'
require 'imagga'

module Tagger
  class Imagga
    attr_reader :tags

    def initialize(api_key, api_secret)
      ::Imagga::Swagger.configure do |config|
        config.username = api_key
        config.password = api_secret
      end
    end

    def success?
      @tags.present?
    end

    def retrieve_tags(image_url)
      Rails.logger.info "[IMAGGA] retrieving tags for #{image_url}"
      begin
        resp = ::Imagga::TaggingAPI.tagging url: image_url
        @tags = resp.results.first.tags.map do |tag|
          {
            name: tag.tag,
            confidence: tag.confidence
          }
        end if resp.results.any?
      rescue ::Imagga::HTTPError => e
        @tags = nil
        Rails.logger.error "#{e}"
      end
      self
    end
  end
end
