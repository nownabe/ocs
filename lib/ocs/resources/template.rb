module Ocs
  module Resources
    class Template < Base
      define_attribute :displaytext, type: String
      define_attribute :name, type: String
    end
  end
end
