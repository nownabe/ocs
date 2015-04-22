module Ocs
  module Resources
    class Iso < Base
      define_attribute :displaytext, type: String
      define_attribute :name, type: String
    end
  end
end
