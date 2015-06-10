module Ocs
  class OcsError < StandardError; end
  class AttributeClassMismatch < OcsError; end
  class AttributeTypeMismatch < OcsError; end
  class MissingKey < OcsError; end
end
