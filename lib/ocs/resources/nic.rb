module Ocs
  module Resources
    class Nic < Base
      has_one :network

      define_attribute :broadcasturi, type: String
      define_attribute :gateway, type: String
      define_attribute :ipaddress, type: String
      define_attribute :isdefault, type: [TrueClass, FalseClass]
      define_attribute :isolationuri, type: String
      define_attribute :macaddress, type: String
      define_attribute :netmask, type: String
      define_attribute :networkid, type: String
      define_attribute :networkname, type: String
      define_attribute :traffictype, type: String
      define_attribute :type, type: String

      delegate_attribute :networkid, to: :network, as: :id
      delegate_attribute :networkname, to: :network, as: :name
    end
  end
end
