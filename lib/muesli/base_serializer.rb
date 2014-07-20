module Muesli
  class BaseSerializer
    @whitelisted_attributes = []

    class << self
      attr_accessor :whitelisted_attributes
    end

    attr_accessor :model, :user

    def initialize(model)
      self.model = model
    end

    def to_hash
      return serialize_attributes(self.class.whitelisted_attributes)
    end

    protected

    def serialize_attributes(attribute_list)
      return attribute_list.reduce({}) do |memo, attr|
        memo[attr] = serialize_value( model.send(attr) )
        memo
      end
    end

    def serialize_value(value)
      if [ Date, DateTime, Time ].include? value.class
        return serialize_date(value)
      end

      return value
    end

    def normalize_dates_to_time(date)
      return date.to_time if date.is_a? Date
      return date.to_time if date.is_a? DateTime
      return date         if date.is_a? Time

      return nil
    end

    def serialize_date(date)
      date = normalize_dates_to_time(date)

      return nil unless date

      return date.iso8601
    end
  end
end
