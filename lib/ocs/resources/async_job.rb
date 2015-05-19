module Ocs
  module Resources
    class AsyncJob < Base
      define_attribute :jobid, type: String
      define_attribute :jobstatus, type: Integer

      def done?
        reload!
        jobstatus != 0
      end

      def failed?
        reload!
        jobstatus == 2
      end

      def success?
        reload!
        jobstatus == 1
      end

      def reload!
        res = client.call("queryAsyncJobResult", jobid: jobid)
        self.jobstatus = res[:jobstatus]
      end
    end
  end
end
