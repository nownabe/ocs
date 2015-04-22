module Ocs
  module Resources
    class Template < Base
      has_one :account
      has_one :domain
      has_one :host
      has_one :os_type
      has_one :project
      has_one :template
      has_one :zone

      has_many :tags

      define_attribute :bootable, type: BOOLEAN
      define_attribute :checksum, type: String
      define_attribute :created, type: String
      define_attribute :crossZones, type: BOOLEAN
      define_attribute :details, type: Hash
      define_attribute :displaytext, type: String
      define_attribute :format, type: String
      define_attribute :hypervisor, type: String
      define_attribute :isdynamicallyscalable, type: BOOLEAN
      define_attribute :isextractable, type: BOOLEAN
      define_attribute :isfeatured, type: BOOLEAN
      define_attribute :ispublic, type: BOOLEAN
      define_attribute :isready, type: BOOLEAN
      define_attribute :name, type: String
      define_attribute :passwordenabled, type: BOOLEAN
      define_attribute :removed, type: BOOLEAN
      define_attribute :size, type: Integer
      define_attribute :sshkeyenabled, type: BOOLEAN
      define_attribute :status, type: String
      define_attribute :templatetag, type: String
      define_attribute :templatetype, type: String

      delegate_attribute :account,   to: :account, as: :name
      delegate_attribute :accountid, to: :account, as: :id
      delegate_attribute :domain,   to: :domain, as: :name
      delegate_attribute :domainid, to: :domain, as: :id
      delegate_attribute :hostid,   to: :host, as: :id
      delegate_attribute :hostname, to: :host, as: :name
      delegate_attribute :ostypeid,   to: :os_type, as: :id
      delegate_attribute :ostypename, to: :os_type, as: :name
      delegate_attribute :project,   to: :project, as: :name
      delegate_attribute :projectid, to: :project, as: :id
      delegate_attribute :sourcetemplateid, to: :template, as: :id
      delegate_attribute :zoneid,   to: :zone, as: :id
      delegate_attribute :zonename, to: :zone, as: :name

      delegate_attributes :tags, to: :tags
    end
  end
end
