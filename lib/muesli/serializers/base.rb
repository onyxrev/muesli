module Muesli
  module Serializers
    class Base
      class << self
        attr_accessor :whitelisted_attributes
      end

      attr_accessor :model, :user

      def initialize(model)
        self.model = model
      end

      def serialize
        return serialize_from_model(self.class.whitelisted_attributes || [])
      end

      protected

      def serialize_from_model(attribute_list)
        serialize_attributes(model, attribute_list)
      end

      def serialize_attributes(attribute_source, attribute_list)
        return attribute_list.map do |attr|
          map_from_source(attribute_source, attr)
        end.compact.to_h
      end

      def map_from_source(attribute_source, attr)
        if attribute_source.respond_to?(attr)
          begin
            [ attr, serialize_value( attribute_source.send(attr) ) ]
          rescue ActiveModel::MissingAttributeError
            nil
          end
        end
      end

      def serialize_value(value)
        if Muesli::AttributeSerializers.const_defined?(value.class.to_s, false)
          return Muesli::AttributeSerializers.const_get(value.class.to_s, false).new(value).serialize
        else
          return Muesli::AttributeSerializers::Base.new(value).serialize
        end
      end
    end
  end
end
