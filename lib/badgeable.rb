module Badgeable

  def badge_callbacks
    @badge_callbacks ||= {}
  end
  
  def badge(*args, &blk)
    opts = args.last.is_a?(Hash) ? args.pop : {}
    name = args.shift
    badge_callbacks[name] = blk
  end

  module InstanceMethods
    
    def def_badge(*args, &blk)
      self.class.badge(*args, &blk)
    end
    
    def badges
      self.class.badge_callbacks.keys.select do |k|
        self.class.badge_callbacks[k].call(self)
      end
    end
    
  end
    
end
