module Ocs
  module Resources
    class AttributeTypeError < OcsError; end
    class AttributeClassError < OcsError; end
    class MissingKeyError < OcsError; end

    class Base
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

        # Dynamic Definitions

        def alias_attribute(new_name, original_name)
          alias_method new_name, original_name
          alias_method :"#{new_name}=", :"#{original_name}="
        end

        def define_action(action_name, required: [], optional: [], api_name: nil)
          define_method(action_name) do |special_parameters = {}|
            api = api_name || "#{action_name}#{self.class.name}"
            parameters = action_parameters(required, optional).merge(special_parameters)
            send_and_update(api, parameters)
          end
        end

        def define_attribute(attribute_name, type:)
          define_method(:"#{attribute_name}=") do |value|
            unless [*type].any? { |type| value.is_a?(type) }
              raise AttributeTypeError.new(
                "#{attribute_name} needs to be a #{[*type].join(" or ")}"
              )
            end
            instance_variable_set(:"@#{attribute_name}", value)
          end

          attr_reader attribute_name
        end

        def delegate_attribute(attribute_name, to:, as:)
          writer_method_name = :"#{to}_#{as}="
          define_method(writer_method_name) do |value|
            instance =
              public_send(to) ||
              public_send(:"#{to}=", resource_class(to).new(client))
            instance.public_send(:"#{as}=", value)
          end
          delegations[attribute_name] = writer_method_name

          define_method(:"#{to}_#{as}") do
            instance = public_send(to)
            instance && instance.public_send(as)
          end
        end

        def delegate_attributes(attribute_name, to:)
          delegations[attribute_name] = :"#{to}="
        end

        def has_one(attribute_name)
          define_method(:"#{attribute_name}=") do |value|
            klass = resource_class(attribute_name)
            unless value.instance_of?(klass)
              raise AttributeClassError.new(
                "#{attribute_name} needs to be an instance of #{klass}"
              )
            end
            instance_variable_set(:"@#{attribute_name}", value)
          end

          attr_reader attribute_name
        end

        def has_many(attribute_name)
          define_method(:"#{attribute_name}=") do |values|
            unless values.is_a?(Array)
              raise AttributeTypeError.new("#{attribute_name} needs to be a Array")
            end

            klass = resource_class(attribute_name.to_s.singularize)
            instances = values.map do |value|
              case value
              when klass
                value
              when Hash
                klass.new(client, value)
              else
                raise AttributeClassError.new(
                  "elements of #{attribute_name} need to be instances of #{klass}"
                )
              end
            end
            instance_variable_set(:"@#{attribute_name}", instances)
          end

          attr_reader attribute_name
        end
      end

      define_attribute :id, type: String

      attr_reader :client, :error

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
          true
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
