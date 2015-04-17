module Ocs
  class Response
    def initialize(faraday_response)
      @raw_body    = faraday_response.body
      @raw_headers = faraday_response.headers
      @raw_status  = faraday_response.status
    end

    def body
      @body ||= @raw_body.with_indifferent_access
    end

    def status
      @raw_status
    end
  end
end
