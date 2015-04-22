module Ocs
  module Resource
    class AsyncJob < Base
      define_attribute :jobid, type: String
      define_attribute :jobstatus, type: Integer
    end
  end
end
