module Muesli
  module AttributeSerializers
    class Time < Base
      def serialize
        return @attribute_value.iso8601
      end
    end
  end
end
