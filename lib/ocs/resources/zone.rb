module Ocs
  module Resources
    class Zone < Base
      has_one :domain

      has_many :tags

      define_attribute :allocationstate, type: String
      define_attribute :capacity, type: Hash
      define_attribute :description, type: String
      define_attribute :dhcpprovider, type: String
      define_attribute :displaytext, type: String
      define_attribute :dns1, type: String
      define_attribute :dns2, type: String
      define_attribute :guestcidraddress, type: String
      define_attribute :internaldns1, type: String
      define_attribute :internaldns2, type: String
      define_attribute :ip6dns1, type: String
      define_attribute :ip6dns2, type: String
      define_attribute :localstorageenabled, type: BOOLEAN
      define_attribute :name, type: String
      define_attribute :networktype, type: String
      define_attribute :resourcedetails, type: Hash
      define_attribute :securitygroupsenabled, type: BOOLEAN
      define_attribute :vlan, type: String
      define_attribute :zonetoken, type: String

      delegate_attribute :domain,   to: :domain, as: :name
      delegate_attribute :domainid, to: :domain, as: :id

      delegate_attributes :tags, to: :tags
    end
  end
end
