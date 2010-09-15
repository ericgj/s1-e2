module Badgeable

  def badge_callbacks
    @badge_callbacks ||= {}
  end
  
  def badge(*args, &blk)
    opts = args.last.is_a?(Hash) ? args.pop : {}
    name = args.shift
    badge_callbacks[name] = (blk || Proc.new {true})
  end
     
  module InstanceMethods
    
    # sugar for defining badges on the fly
    def def_badge(*args, &blk)
      self.class.badge(*args, &blk)
    end
    
    def has_badge?(name)
      eval_badge(name)
    end
    
    def badges
      self.class.badge_callbacks.keys.select do |k|
        eval_badge(k)
      end
    end
    
    def eval_badge(name)
      memoized_badges[name] ||= \
        self.class.badge_callbacks[name].call(self)
    end

    protected
    
    def memoized_badges
      @memoized_badges ||= {}
    end

  end
  
end
