module Ocs
  module Resources
    class Tag < Base
      has_one :account
      has_one :domain
      has_one :project
      has_one :resource_detail

      define_attribute :key, type: String
      define_attribute :value, type: String
      define_attribute :resourcetype, type: String

      delegate_attribute :account, to: :account, as: :name
      delegate_attribute :domain,   to: :domain, as: :name
      delegate_attribute :domainid, to: :domain, as: :id
      delegate_attribute :project,   to: :project, as: :id
      delegate_attribute :projectid, to: :project, as: :id
      delegate_attribute :resourceid,   to: :resource_detail, as: :id
      delegate_attribute :resourcetype, to: :resource_detail, as: :type
    end
  end
end
