module Ocs
  class Request
    attr_reader :name, :options, :client

    def initialize(name:, options: {}, client:)
      @name    = name
      @options = options
      @client  = client
    end

    def send
      Response.new(connection.get(path, escaped_parameters, headers))
    end

    private

    def api_key
      client.api_key
    end

    def connection
      client.connection
    end

    def escape(string)
      URI.escape(string)
    end

    def escaped_parameters
      escaped_parameters_without_signature.merge(
        signature: escaped_signature
      )
    end

    def escaped_parameters_without_signature
      @escaped_parameters_without_signature ||=
        parameters_without_signature.inject({}) do |escaped_hash, (key, value)|
          escaped_hash[key] = escape(value)
          escaped_hash
        end
    end

    def escaped_signature
      escape(signature)
    end

    def headers
      nil
    end

    def parameters_without_signature
      options.merge(
        command: name,
        apikey: api_key,
        response: "json"
      )
    end

    def path
      client.path
    end

    def secret_key
      client.secret_key
    end

    def signature
      Base64.encode64(
        OpenSSL::HMAC::digest(
          OpenSSL::Digest::SHA1.new,
          secret_key,
          signature_seed
        )
      ).chomp
    end

    def signature_seed
      sorted_parameters =
        escaped_parameters_without_signature.to_a.sort do |a, b|
          a[0] <=> b[0]
        end
      sorted_parameters.map { |param| param.join("=") }.join("&").downcase
    end
  end
end
