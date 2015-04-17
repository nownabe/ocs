module Resources
  class VirtualMachine < Base
    belongs_to :service_offering
    belongs_to :template
    belongs_to :zone

    define_attribute :displayname, type: String
    define_attribute :group, type: String
    define_attribute :name, type: String

    define_method :deploy,
      required: %i(service_offering_id template_id zone_id),
      optional: %i(displayname group name),
      repeat: false
  end
end
