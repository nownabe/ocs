module Ocs
  module Resources
    class Domain < Base
      has_one :domain

      define_attribute :haschild, type: BOOLEAN
      define_attribute :level, type: Integer
      define_attribute :name, type: String
      define_attribute :path, type: String

      delegate_attribute :parentdomainid,   to: :domain, as: :id
      delegate_attribute :parentdomainname, to: :domain, as: :name
    end
  end
end
