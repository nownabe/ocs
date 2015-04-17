require "faraday"

module Ocs
  class Client
    attr_reader :api_key, :host, :path, :secret_key

    def initialize(host:, api_key:, secret_key:, path: "/client/api", dry: false, logger: nil)
      @host       = host
      @api_key    = api_key
      @secret_key = secret_key
      @path       = path
      @dry        = dry
      @logger     = logger
    end

    def call(name, options = {})
      Request.new(
        name: name,
        options: options,
        client: self
      ).call
    end

    def connection
      @connection ||=
        Faraday.new(url: url_prefix) do |connection|
          connection.response :json
          connection.adapter Faraday.default_adapter
        end
    end

    def new(resource_name, options)
      resource_class(resource_name).new(client, options)
    end

    private

    def dry?
      !!@dry
    end

    def resource_class(resource_name)
      "resource/#{resource_name}".camelize.constantize
    end

    def url_prefix
      "https://#{host}"
    end

    def method_missing(method, *args)
      if Resources.const_defined?(args.first.camelize)
        klass_name, *arguments = args
        resource_class(klass_name).public_send(method, client, *arguments)
      else
        super
      end
    end
  end
end
