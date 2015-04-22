module Ocs
  class Client
    attr_reader :api_key, :host, :path, :secret_key, :logger

    def initialize(host:, api_key:, secret_key:, path: "/client/api", logger: nil)
      @host       = host
      @api_key    = api_key
      @secret_key = secret_key
      @path       = path
      @logger     = logger
    end

    def call(name, options = {})
      send(name, options)
        .body["#{name.downcase.pluralize}response"]
    end

    def connection
      @connection ||=
        Faraday.new(url: url_prefix) do |connection|
          connection.response :json
          connection.adapter Faraday.default_adapter
        end
    end

    def new(resource_name, options = {})
      resource_class(resource_name).new(self, options)
    end

    def send(name, options = {})
      Request.new(
        name: name,
        options: options,
        client: self
      ).send
    end

    private

    def resource_class(resource_name)
      "ocs/resources/#{resource_name}".camelize.constantize
    end

    def url_prefix
      "https://#{host}"
    end

    def method_missing(method, *args)
      return super unless args.first.to_s =~ /^[a-zA-Z]/
      
      raw_resource_name, *arguments = args
      resource_name = raw_resource_name.to_s.singularize
      if Resources.const_defined?(resource_name.camelize)
        return resource_class(resource_name).public_send(method, self, *arguments)
      end

      super
    end
  end
end
