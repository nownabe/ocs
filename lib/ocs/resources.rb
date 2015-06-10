require "ocs/resources/dynamic_definers"
require "ocs/resources/base"

module Ocs
  module Resources
    autoload :Account,         "ocs/resources/account"
    autoload :Address,         "ocs/resources/address"
    autoload :AffinityGroup,   "ocs/resources/affinity_group"
    autoload :AsyncJob,        "ocs/resources/async_job"
    autoload :DiskOffering,    "ocs/resources/disk_offering"
    autoload :Domain,          "ocs/resources/domain"
    autoload :Group,           "ocs/resources/group"
    autoload :Host,            "ocs/resources/host"
    autoload :Iso,             "ocs/resources/iso"
    autoload :Network,         "ocs/resources/network"
    autoload :Nic,             "ocs/resources/nic"
    autoload :OsType,          "ocs/resources/os_type"
    autoload :ResourceDetail,  "ocs/resources/resource_detail"
    autoload :SecurityGroup,   "ocs/resources/security_group"
    autoload :ServiceOffering, "ocs/resources/service_offering"
    autoload :SshKeyPair,      "ocs/resources/ssh_key_pair"
    autoload :Tag,             "ocs/resources/tag"
    autoload :Template,        "ocs/resources/template"
    autoload :VirtualMachine,  "ocs/resources/virtual_machine"
    autoload :Zone,            "ocs/resources/zone"
  end
end
