module Muesli
  module AttributeSerializers
    class DateTime < Time
      def initialize
        super

        @value = @value.to_time
      end
    end
  end
end
