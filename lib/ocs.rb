require "base64"
require "openssl"
require "uri"

require "active_support/core_ext/string/inflections"
require "active_support/core_ext/hash/indifferent_access"
require "faraday"
require "faraday_middleware"

module Ocs
  class OcsError < StandardError; end
end

require "ocs/client"
require "ocs/request"
require "ocs/resources"
require "ocs/response"
require "ocs/version"
