module Ocs
  module Resources
    class ServiceOffering < Base
      has_one :domain

      define_attribute :cpunumber, type: Integer
      define_attribute :cpuspeed, type: Integer
      define_attribute :created, type: String
      define_attribute :defaultuse, type: BOOLEAN
      define_attribute :deploymentplanner, type: String
      define_attribute :diskBytesReadRate, type: Integer
      define_attribute :diskBytesWriteRate, type: Integer
      define_attribute :diskIopsReadRate, type: Integer
      define_attribute :diskIopsWriteRate, type: Integer
      define_attribute :displaytext, type: String
      define_attribute :hosttags, type: String
      define_attribute :iscustomized, type: BOOLEAN
      define_attribute :issystem, type: BOOLEAN
      define_attribute :isvolatile, type: BOOLEAN
      define_attribute :limitcpuuse, type: BOOLEAN
      define_attribute :memory, type: Integer
      define_attribute :name, type: String
      define_attribute :networkrate, type: Integer
      define_attribute :offerha, type: BOOLEAN
      define_attribute :serviceofferingdetails, type: Hash
      define_attribute :storagetype, type: String
      define_attribute :systemvmtype, type: String
      define_attribute :tags, type: String

      delegate_attribute :domain,   to: :domain, as: :name
      delegate_attribute :domainid, to: :domain, as: :id
    end
  end
end
