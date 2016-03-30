require "ocs/resources/dynamic_definers"
require "ocs/resources/base"

module Ocs
  module Resources
  end
end

Dir[File.expand_path("../resources/**/*.rb", __FILE__)].each { |f| require f }
