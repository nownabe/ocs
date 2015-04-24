module Ocs
  class Response
    attr_reader :raw_body

    def initialize(faraday_response)
      @raw_body    = faraday_response.body.with_indifferent_access
      @raw_headers = faraday_response.headers
      @raw_status  = faraday_response.status
    end

    def content
      @content ||= raw_body[response_key]
    end

    def response_key
      @response_key ||= raw_body.keys.first
    end

    def status
      @raw_status
    end
  end
end
