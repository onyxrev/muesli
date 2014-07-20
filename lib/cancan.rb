module Muesli
  module CanCan
    attr_accessor :ability

    def for_user(user)
      self.user    = user
      self.ability = Ability.new(user)

      return self
    end

    protected

    def can?(*args)
      return false unless user

      ability.can? *args
    end

    def cannot?(*args)
      return true unless user

      ability.cannot *args
    end
  end
end
