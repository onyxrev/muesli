module Muesli
  module AttributeSerializers
    module Moped
      module BSON
        class ObjectId < Muesli::AttributeSerializers::Base
          def serialize
            return @value.to_s
          end
        end
      end
    end
  end
end
