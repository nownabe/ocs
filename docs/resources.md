Resouces
========

## Account
### Attributes

Attribute | Type
---|---
name | String

## Address
### Attributes

Attribute | Type
---|---

## AffinityGroup
### Attributes

Attribute | Type
---|---

## AsyncJob
### Attributes

Attribute | Type
---|---
jobid | String
jobstatus | Integer

## Base
### Attributes

Attribute | Type
---|---

## DiskOffering
### Attributes

Attribute | Type
---|---
name | String

## Domain
### Attributes

Attribute | Type
---|---
haschild | [TrueClass, FalseClass]
level | Integer
name | String
path | String

## Group
### Attributes

Attribute | Type
---|---
name | String

## Host
### Attributes

Attribute | Type
---|---
name | String

## Iso
### Attributes

Attribute | Type
---|---
displaytext | String
name | String

## Network
### Attributes

Attribute | Type
---|---
account | String
aclid | String
acltype | String
broadcastdomaintype | String
broadcasturi | String
canusefordeploy | [TrueClass, FalseClass]
cidr | String
displaynetwork | [TrueClass, FalseClass]
displaytext | String
dns1 | String
dns2 | String
gateway | String
ip6cidr | String
ip6gateway | String
isdefault | [TrueClass, FalseClass]
ispersistent | [TrueClass, FalseClass]
issystem | [TrueClass, FalseClass]
name | String
netmask | String
networkcidr | String
networkdomain | String
networkofferingavailability | String
networkofferingconservemode | [TrueClass, FalseClass]
networkofferingdisplaytext | String
networkofferingid | String
networkofferingname | String
physicalnetworkid | String
related | String
reservediprange | String
restartrequired | [TrueClass, FalseClass]
service | Array
specifyipranges | [TrueClass, FalseClass]
state | String
subdomainaccess | [TrueClass, FalseClass]
traffictype | String
type | String
vlan | String
vpcid | String

## Nic
### Attributes

Attribute | Type
---|---
broadcasturi | String
gateway | String
ipaddress | String
isdefault | [TrueClass, FalseClass]
isolationuri | String
macaddress | String
netmask | String
networkid | String
networkname | String
traffictype | String
type | String

## OsType
### Attributes

Attribute | Type
---|---
description | String

## ResourceDetail
### Attributes

Attribute | Type
---|---
type | String

## SecurityGroup
### Attributes

Attribute | Type
---|---

## ServiceOffering
### Attributes

Attribute | Type
---|---
cpunumber | Integer
cpuspeed | Integer
created | String
defaultuse | [TrueClass, FalseClass]
deploymentplanner | String
diskBytesReadRate | Integer
diskBytesWriteRate | Integer
diskIopsReadRate | Integer
diskIopsWriteRate | Integer
displaytext | String
hosttags | String
iscustomized | [TrueClass, FalseClass]
issystem | [TrueClass, FalseClass]
isvolatile | [TrueClass, FalseClass]
limitcpuuse | [TrueClass, FalseClass]
memory | Integer
name | String
networkrate | Integer
offerha | [TrueClass, FalseClass]
serviceofferingdetails | Hash
storagetype | String
systemvmtype | String
tags | String

## SshKeyPair
### Attributes

Attribute | Type
---|---
fingerprint | String
name | String

## Tag
### Attributes

Attribute | Type
---|---
key | String
value | String
resourcetype | String

## Template
### Attributes

Attribute | Type
---|---
bootable | [TrueClass, FalseClass]
checksum | String
created | String
crossZones | [TrueClass, FalseClass]
details | Hash
displaytext | String
format | String
hypervisor | String
isdynamicallyscalable | [TrueClass, FalseClass]
isextractable | [TrueClass, FalseClass]
isfeatured | [TrueClass, FalseClass]
ispublic | [TrueClass, FalseClass]
isready | [TrueClass, FalseClass]
name | String
passwordenabled | [TrueClass, FalseClass]
removed | [TrueClass, FalseClass]
size | Integer
sshkeyenabled | [TrueClass, FalseClass]
status | String
templatetag | String
templatetype | String

## VirtualMachine
### Attributes

Attribute | Type
---|---
cpunumber | Integer
cpuspeed | Integer
cpuused | String
created | String
displayname | String
displayvm | [TrueClass, FalseClass]
haenable | [TrueClass, FalseClass]
hypervisor | String
instancename | String
isdynamicallyscalable | [TrueClass, FalseClass]
memory | Integer
name | String
networkkbsread | Integer
networkkbswrite | Integer
passwordenabled | [TrueClass, FalseClass]
rootdeviceid | Integer
rootdevicetype | String
state | String

## Zone
### Attributes

Attribute | Type
---|---
allocationstate | String
capacity | Hash
description | String
dhcpprovider | String
displaytext | String
dns1 | String
dns2 | String
guestcidraddress | String
internaldns1 | String
internaldns2 | String
ip6dns1 | String
ip6dns2 | String
localstorageenabled | [TrueClass, FalseClass]
name | String
networktype | String
resourcedetails | Hash
securitygroupsenabled | [TrueClass, FalseClass]
vlan | String
zonetoken | String

