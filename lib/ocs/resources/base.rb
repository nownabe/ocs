module Resources
  class AttributeTypeError < OcsError; end
  class AttributeClassError < OcsError; end

  class Base
    class << self
      def belongs_to(klass_name)
        define_method(:"#{klass_name}=") do |value|
          klass = klass_name.camelize.constantize
          unless value.instance_of?(klass)
            raise AttributeClassError.new(
              "#{klass_name} needs to be instance of #{klass}"
            )
          end
          instance_variable_set(:"@#{klass_name}", value)
        end

        attr_reader klass_name
      end

      def define_attribute(attribute_name, type:)
        define_method(:"#{attribute_name}=") do |value|
          raise AttributeTypeError.new("#{attribute_name}") unless value.is_a?(type)
          instance_variable_set(:"@#{attribute_name}", value)
        end

        attr_reader attribute_name
      end

      def create_from_hash(client, hash)
        new(client, hash)
      end

      def list(client, parameters)

      end

      def where(client, conditions)

      end
    end

    def initialize(client, options)
      @client  = client
      @options = options
      parse_options
    end

    private

    def initialize_options
      @options.each do |key, val|
        self.send("#{key}=", val)
      end
    end

    def method_missing(method, *args)
      
    end
  end
end
