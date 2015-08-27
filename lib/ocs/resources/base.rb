module Ocs
  module Resources
    class Base
      include DynamicDefiners

      BOOLEAN = [TrueClass, FalseClass].freeze

      class_attribute :delegations, instance_writer: false
      self.delegations = {}

      class << self
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
