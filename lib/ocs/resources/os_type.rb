module Ocs
  module Resources
    class OsType < Base
      define_attribute :description, type: String

      alias_attribute :name, :description
    end
  end
end
