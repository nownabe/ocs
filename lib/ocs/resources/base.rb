module Ocs
  module Resources
    class AttributeTypeError < OcsError; end
    class AttributeClassError < OcsError; end

    class Base
      class_attribute :delegations, instance_writer: false
      self.delegations = {}

      class << self
        def all(client)
          where(client)
        end

        def downcased_name
          name.downcase
        end

        def name
          to_s.split(/::/).last
        end

        def pluralized_name
          name.pluralize
        end

        def underscore
          name.underscore
        end

        def where(client, conditions = {})
          client.call("list#{pluralized_name}", conditions)[downcased_name].map do |attributes|
            new(client, attributes)
          end
        end

        # Dynamic Definitions

        def define_action(action_name, required: [], optional: [])
          define_method(action_name) do
            call
          end
        end

        def define_attribute(attribute_name, type:, &block)
          define_method(:"#{attribute_name}=") do |value|
            unless [*type].any? { |type| value.is_a?(type) }
              raise AttributeTypeError.new(
                "#{attribute_name} needs to be a #{[*type].join(" or ")}"
              )
            end
            set_value = if block
                block.call(value)
              else
                value
              end
            instance_variable_set(:"@#{attribute_name}", set_value)
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

      attr_reader :client

      def initialize(client, raw_hash = {})
        @client   = client
        @raw_hash = raw_hash
        update_attributes(raw_hash)
      end

      private

      def update_attributes(hash)
        hash.each do |key, value|
          if delegations.has_key?(key.to_sym)
            public_send(delegations[key.to_sym], value)
          else
            public_send(:"#{key}=", value)
          end
        end
      end

      def resource_class(class_name)
        "ocs/resources/#{class_name}".camelize.constantize
      end
    end
  end
end
