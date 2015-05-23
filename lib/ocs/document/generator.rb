require "active_support/core_ext/class/attribute"
require "active_support/core_ext/string/inflections"

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
      end

      private

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
