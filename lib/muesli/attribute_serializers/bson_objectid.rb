module Muesli
  module AttributeSerializers
    module BSON
      class ObjectId < Base
        def serialize
          return @value.to_s
        end
      end
    end
  end
end
