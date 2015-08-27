require "base64"
require "openssl"
require "uri"

require "active_support/concern"
require "active_support/core_ext/class/attribute"
require "active_support/core_ext/hash/indifferent_access"
require "active_support/core_ext/object/blank"
require "active_support/core_ext/string/inflections"
require "faraday"
require "faraday_middleware"

module Ocs
end

require "ocs/errors"
require "ocs/api_error"
require "ocs/client"
require "ocs/request"
require "ocs/resources"
require "ocs/response"
require "ocs/version"
