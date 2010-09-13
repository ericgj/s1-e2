module Badgeable
module ClassMethods

  def badge_callbacks
    @badge_callbacks ||= {}
  end
  
  def badge(*args, &blk)
    opts = args.last.is_a?(Hash) ? args.pop : {}
    name = args.shift
    badge_callbacks[name] = blk
  end

end

module InstanceMethods
  
  def badges
    self.class.badge_callbacks.keys.select do |k|
      self.class.badge_callbacks[k].call(self)
    end
  end
  
end
  
end
