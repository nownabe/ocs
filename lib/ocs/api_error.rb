module Ocs
  class ApiError < OcsError
    attr_reader :api, :parameters, :error_response

    def initialize(api, parameters, error_response)
      @api = api
      @parameters = parameters
      @error_response = error_response
    end

    def error_code
      error_response.content[:cserrorcode]
    end

    def error_text
      error_response.content[:errortext]
    end

    def message
      {
        api: api,
        parameters: parameters,
        error_response: error_response.raw_body
      }
    end

    def status_code
      error_response.content[:errorcode]
    end

    def to_s
      "[#{error_code}] #{error_text}"
    end
  end
end
