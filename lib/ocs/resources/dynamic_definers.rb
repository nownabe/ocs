module Ocs
  module Resources
    module DynamicDefiners
      extend ActiveSupport::Concern

      module ClassMethods
        def alias_attribute(alias_name, original_name)
          alias_method alias_name, original_name
          alias_method :"#{alias_name}=", :"#{original_name}="
        end

        def define_action(action_name, required: [], optional: [], api_name: nil)
          define_method(action_name) do |special_parameters = {}|
            api = api_name || "#{action_name}#{self.class.name}"
            parameters = action_parameters(required, optional).merge(special_parameters)
            send_and_update(api, parameters)
          end

          define_method(:"#{action_name}!") do |special_parameters = {}|
            send(action_name) || fail(@error)
          end
        end

        def define_attribute(attribute_name, type:)
          define_method(:"#{attribute_name}=") do |value|
            unless [*type].any? { |t| value.is_a?(t) }
              fail AttributeTypeMismatch.new(
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
              fail AttributeClassMismatch.new(
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
              fail AttributeTypeMismatch.new("#{attribute_name} needs to be an Array")
            end

            klass = resource_class(attribute_name.to_s.singularize)
            instances = values.map do |value|
              case value
              when klass
                value
              when Hash
                klass.new(client, value)
              else
                fail AttributeClassMismatch.new(
                  "Elements of #{attribute_name} need to be instances of #{klass} or Hash"
                )
              end
            end
            instance_variable_set(:"@#{attribute_name}", instances)
          end

          attr_reader attribute_name
        end
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
        keys.each_with_object({}) do |key, params|
          attribute_name = key.is_a?(Hash) ? key[:attribute] : key
          request_key = key.is_a?(Hash) ? key[:as].to_s : key.to_s.delete("_")
          value = public_send(attribute_name)
          params[request_key] = value if value
        end
      end
    end
  end
end
