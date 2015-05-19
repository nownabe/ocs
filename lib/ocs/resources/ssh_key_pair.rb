module Ocs
  module Resources
    class SshKeyPair < Base
      class << self
        def name
          "SSHKeyPair"
        end
      end

      define_attribute :fingerprint, type: String
      define_attribute :name, type: String
    end
  end
end
