require_relative 'form_request'
require 'open-uri'
require 'hashie'
Hash.send :include, Hashie::Extensions

module ResponsesApi
  class RetrieveFormRequest < FormRequest
    ISO_8601_FORMAT = '%Y-%m-%dT%H:%M:%S'.freeze

    def initialize(form_id, token: APIConfig.token)
      url = "#{APIConfig.api_request_url}/forms/#{form_id}"
      r = {
        method: :get,
        url: url
      }
      r[:headers] = { 'Authorization' => "Bearer #{token}" } unless token.nil?

      request(r)
    end

    def success?
      @response.code == 200 && json?
    end

    def fields(hashie: true)
      if hashie
        Hashie::Mash.new(json).fields
      else
        json.fetch(:fields)
      end
    end

    def page_count
      json.fetch(:page_count)
    end

    def total_items
      json.fetch(:total_items)
    end
  end
end
