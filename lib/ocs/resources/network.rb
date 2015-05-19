module Ocs
  module Resources
    class Network < Base
      has_one :domain
      has_one :project
      has_one :zone

      has_many :tags

      define_attribute :account, type: String
      define_attribute :aclid, type: String
      define_attribute :acltype, type: String
      define_attribute :broadcastdomaintype, type: String
      define_attribute :broadcasturi, type: String
      define_attribute :canusefordeploy, type: BOOLEAN
      define_attribute :cidr, type: String
      define_attribute :displaynetwork, type: BOOLEAN
      define_attribute :displaytext, type: String
      define_attribute :dns1, type: String
      define_attribute :dns2, type: String
      define_attribute :gateway, type: String
      define_attribute :ip6cidr, type: String
      define_attribute :ip6gateway, type: String
      define_attribute :isdefault, type: BOOLEAN
      define_attribute :ispersistent, type: BOOLEAN
      define_attribute :issystem, type: BOOLEAN
      define_attribute :name, type: String
      define_attribute :netmask, type: String
      define_attribute :networkcidr, type: String
      define_attribute :networkdomain, type: String
      define_attribute :networkofferingavailability, type: String
      define_attribute :networkofferingconservemode, type: BOOLEAN
      define_attribute :networkofferingdisplaytext, type: String
      define_attribute :networkofferingid, type: String
      define_attribute :networkofferingname, type: String
      define_attribute :physicalnetworkid, type: String
      define_attribute :related, type: String
      define_attribute :reservediprange, type: String
      define_attribute :restartrequired, type: BOOLEAN
      define_attribute :service, type: Array
      define_attribute :specifyipranges, type: BOOLEAN
      define_attribute :state, type: String
      define_attribute :subdomainaccess, type: BOOLEAN
      define_attribute :traffictype, type: String
      define_attribute :type, type: String
      define_attribute :vlan, type: String
      define_attribute :vpcid, type: String

      delegate_attribute :domain,   to: :domain, as: :name
      delegate_attribute :domainid, to: :domain, as: :id
      delegate_attribute :project,   to: :project, as: :name
      delegate_attribute :projectid, to: :project, as: :id
      delegate_attribute :zoneid,   to: :zone, as: :id
      delegate_attribute :zonename, to: :zone, as: :name

      delegate_attributes :tags, to: :tags
    end
  end
end
