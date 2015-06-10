module Ocs
  module Resources
    class Base
      BOOLEAN = [TrueClass, FalseClass].freeze

      class_attribute :delegations, instance_writer: false
      self.delegations = {}

      class << self
        include DynamicDefiners

        def all(client)
          list(client)
        end

        def downcased_name
          name.downcase
        end

        def find(client, conditions = {}, parameters = {})
          where(client, conditions, parameters).first
        end

        def inherited(sub_class)
          sub_class.delegations = {}
        end

        def name
          to_s.split(/::/).last
        end

        def pluralized_name
          name.pluralize
        end

        def underscored_name
          name.underscore
        end

        def list(client, parameters = {})
          response = client.call("list#{pluralized_name}", parameters)
          if response.empty?
            []
          else
            response[downcased_name].map do |attributes|
              new(client, attributes)
            end
          end
        end

        def where(client, conditions = {}, parameters = {})
          list(client, parameters).select do |instance|
            conditions.all? do |attribute, condition|
              value = instance.public_send(attribute)
              case condition
              when Regexp
                condition =~ value
              when Range
                condition.include?(value)
              else
                condition == value
              end
            end
          end
        end
      end

      attr_reader :client, :error

      define_attribute :id, type: String

      def initialize(client, raw_hash = {})
        @client   = client
        @raw_hash = raw_hash
        update_attributes!(raw_hash)
      end

      def reload!
        response = client.call("list#{self.class.pluralized_name}", id: id)[self.class.downcased_name]
        if response && !response.empty?
          update_attributes!(response.first)
        end
        self
      end

      private

      def action_parameters(required_keys, optional_keys)
        check_required_keys(required_keys)
        parameters(required_keys + optional_keys)
      end

      def check_required_keys(required_keys)
        required_keys.each do |key|
          key = key[:attribute] if key.is_a?(Hash)
          raise MissingKeyError.new("#{key} key is required") if public_send(key).nil?
        end
      end

      def parameters(keys)
        keys.inject({}) do |params, key|
          attribute_name = key.is_a?(Hash) ? key[:attribute] : key
          request_key = key.is_a?(Hash) ? key[:as].to_s : key.to_s.delete("_")
          value = public_send(attribute_name)
          params[request_key] = value if value
          params
        end
      end

      def resource_class(class_name)
        "ocs/resources/#{class_name}".camelize.constantize
      end

      def send_and_update(api, parameters)
        response = client.send(api, parameters)
        if response.success?
          @error = nil
          update_attributes!(response.content)
          self
        else
          @error = ApiError.new(api, parameters, response)
          false
        end
      end

      def update_attributes!(hash)
        hash.each do |key, value|
          if delegations.has_key?(key.to_sym)
            public_send(delegations[key.to_sym], value)
          else
            public_send(:"#{key}=", value)
          end
        end
      end
    end
  end
end
