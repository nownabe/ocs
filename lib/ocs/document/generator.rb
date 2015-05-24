require "active_support/core_ext/class/attribute"
require "active_support/core_ext/string/inflections"
require "erubis"

module Ocs
  module Document
    class Generator
      class_attribute :resources
      self.resources = {}

      class << self
        def documents_path
          File.expand_path("../../../../docs", __FILE__)
        end

        def library_path
          File.expand_path("../../../", __FILE__)
        end

        def ocs_path
          File.join(library_path, "ocs")
        end
        
        def patches_path
          File.join(ocs_path, "document/patches")
        end

        def resources_path
          File.join(ocs_path, "resources")
        end

        def resource_paths
          Dir[File.join(resources_path, "*.rb")]
        end
      end

      def initialize

      end

      def generate
        require "ocs/errors"
        Patches.patch("ocs/resources/base")
        self.class.resource_paths.each do |resource|
          name = resource.sub(/^.+\//, "").sub(/\.rb$/, "").camelize
          self.class.resources[name] = {}
          require resource
        end
        output
      end

      private

      def output
        output_resources
      end

      def output_resources
        File.write(File.join(self.class.documents_path, "resources.md"), resources_markdown)
      end

      def render_resource_markdown(name, attributes)
        p name
        p attributes
        ::Erubis::Eruby.new(resource_template).evaluate(name: name, attributes: attributes)
      end

      def resource_template
        File.read(File.expand_path("../templates/_resource.md.erb", __FILE__))
      end

      def resources_contents
        self.class.resources.map { |name, attributes| render_resource_markdown(name, attributes) }
      end

      def resources_markdown
        ::Erubis::Eruby.new(resources_template).evaluate { resources_contents.join("\n") }
      end

      def resources_template
        File.read(File.expand_path("../templates/resources.md.erb", __FILE__))
      end
    end

    module Patches
      class << self
        def patch(target_class_path)
          patch_class_path  = "ocs/document/patches/#{target_class_path}"
          require target_class_path
          require patch_class_path
          target_class = target_class_path.camelize.constantize
          patch_class  = patch_class_path.camelize.constantize
          target_class.prepend(patch_class)
          if patch_class.const_defined?(:ClassMethods)
            target_class.singleton_class.instance_eval { self.prepend(patch_class::ClassMethods) }
          end
        end
      end

      module Ocs
        module Resources
          module Base
            module ClassMethods

            end
          end
        end
      end
    end
  end
end
