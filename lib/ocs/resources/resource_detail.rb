module Ocs
  module Resources
    class ResourceDetail < Base
      define_attribute :type, type: String

      alias_attribute :resourceid, :id
      alias_attribute :resourcetype, :type
    end
  end
end
