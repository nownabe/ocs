module Ocs
  module Document
    module Patches
      module Ocs
        module Resources
          module Base
            module ClassMethods
              def define_attribute(attribute_name, type:)
                ::Ocs::Document::Generator.resources[to_s.split(/::/).last][attribute_name] = {type: type}
                super
              end
            end
          end
        end
      end
    end
  end
end
