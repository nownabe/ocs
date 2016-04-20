module Ocs
  module Resources
    class VirtualMachine < Base
      has_one :account
      has_one :address
      has_one :async_job
      has_one :disk_offering
      has_one :domain
      has_one :group
      has_one :host
      has_one :iso
      has_one :os_type
      has_one :project
      has_one :service_offering
      has_one :template
      has_one :ssh_key_pair
      has_one :zone

      has_many :affinity_groups
      has_many :nics
      has_many :security_groups
      has_many :tags

      define_attribute :cpunumber, type: Integer
      define_attribute :cpuspeed, type: Integer
      define_attribute :cpuused, type: String
      define_attribute :created, type: String
      #define_attribute :details
      #define_attribute :diskioread
      #define_attribute :diskiowrite
      #define_attribute :diskkbsread
      #define_attribute :diskkbswrite
      define_attribute :displayname, type: String
      define_attribute :displayvm, type: BOOLEAN
      #define_attribute :forvirtualnetwork
      define_attribute :haenable, type: BOOLEAN
      define_attribute :hypervisor, type: String
      define_attribute :instancename, type: String
      define_attribute :isdynamicallyscalable, type: BOOLEAN
      define_attribute :memory, type: Integer
      define_attribute :name, type: String
      define_attribute :networkkbsread, type: Integer
      define_attribute :networkkbswrite, type: Integer
      #define_attribute :password
      define_attribute :passwordenabled, type: BOOLEAN
      define_attribute :rootdeviceid, type: Integer
      define_attribute :rootdevicetype, type: String
      #define_attribute :servicestate
      define_attribute :state, type: String
      define_attribute :userdata, type: String
      #define_attribute :vgpu

      delegate_attribute :account, to: :account, as: :name
      delegate_attribute :diskofferingid,   to: :disk_offering, as: :id
      delegate_attribute :diskofferingname, to: :disk_offering, as: :name
      delegate_attribute :domain,   to: :domain, as: :name
      delegate_attribute :domainid, to: :domain, as: :id
      delegate_attribute :group,   to: :group, as: :name
      delegate_attribute :groupid, to: :group, as: :id
      delegate_attribute :guestosid, to: :os_type, as: :id
      delegate_attribute :hostid,   to: :host, as: :id
      delegate_attribute :hostname, to: :host, as: :name
      delegate_attribute :isodisplaytext, to: :iso, as: :displaytext
      delegate_attribute :isoid,          to: :iso, as: :id
      delegate_attribute :isoname,        to: :iso, as: :name
      delegate_attribute :jobid,     to: :async_job, as: :jobid
      delegate_attribute :jobstatus, to: :async_job, as: :jobstatus
      delegate_attribute :keypair, to: :ssh_key_pair, as: :name
      delegate_attribute :ostypeid, to: :os_type, as: :id
      delegate_attribute :project,   to: :project, as: :name
      delegate_attribute :projectid, to: :project, as: :id
      delegate_attribute :publicip,   to: :address, as: :id
      delegate_attribute :publicipid, to: :address, as: :id
      delegate_attribute :serviceofferingid,   to: :service_offering, as: :id
      delegate_attribute :serviceofferingname, to: :service_offering, as: :name
      delegate_attribute :templatedisplaytext, to: :template, as: :displaytext
      delegate_attribute :templateid,          to: :template, as: :id
      delegate_attribute :templatename,        to: :template, as: :name
      delegate_attribute :zoneid,   to: :zone, as: :id
      delegate_attribute :zonename, to: :zone, as: :name

      delegate_attributes :affinitygroup, to: :affinity_groups
      delegate_attributes :nic, to: :nics
      delegate_attributes :securitygroup, to: :security_groups
      delegate_attributes :tags, to: :tags

      define_action :deploy,
        required: %i(service_offering_id template_id zone_id),
        optional: %i(displayname name displayvm userdata host_id) + [
          {attribute: :group_name, as: :group},
          {attribute: :ssh_key_pair_name, as: :keypair}
        ]

      define_action :destroy, required: [:id]

      def destroyed?
        state == "Destroyed"
      end

      def running?
        state == "Running"
      end

      def starting?
        state == "Starting"
      end

      def stopped?
        state == "Stopped"
      end

      def add_nic(network:, ipaddress: nil)
        network_id = network.is_a?(Resources::Base) ? network.id : network
        parameters = {networkid: network_id, virtualmachineid: id}
        parameters[:ipaddress] = ipaddress if ipaddress
        send_and_update("addNicToVirtualMachine", parameters)
      end

      def remove_nic(nic:)
        parameters = {nicid: nic.id, virtualmachineid: id}
        send_and_update("removeNicFromVirtualMachine", parameters)
      end

      attr_reader :raw_userdata

      def raw_userdata=(raw_userdata)
        @raw_userdata = raw_userdata
        raw_userdata << "\n" until raw_userdata.bytesize % 3 == 0
        self.userdata = Base64.strict_encode64(raw_userdata)
      end
    end
  end
end
