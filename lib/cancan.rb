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
      ability.can? *args
    end

    def cannot?(*args)
      ability.cannot *args
    end
  end
end
