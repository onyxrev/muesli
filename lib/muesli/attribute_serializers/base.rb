module Muesli
  module AttributeSerializers
    class Base
      def initialize(attribute_value)
        @value = attribute_value
      end

      def serialize
        @value
      end
    end
  end
end
