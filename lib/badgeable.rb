module Badgeable

  def badge_callbacks
    @badge_callbacks ||= {}
  end
  
  def badge_alt_callbacks
    @badge_alt_callbacks ||= {}
  end
  
  def badge_if_callbacks
    @badge_if_callbacks ||= {}
  end
  
  def badge_unless_callbacks
    @badge_unless_callbacks ||= {}
  end
  
  def badge(*args, &blk)
    opts = args.last.is_a?(Hash) ? args.pop : {}
    name = args.shift
    badge_callbacks[name] = (blk || Proc.new {|it| true})
    badge_alt_callbacks[name] = (opts[:alt] || Proc.new {|it| false})
    badge_if_callbacks[name] = opts[:if]
    badge_unless_callbacks[name] = opts[:unless]
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
      return memoized_badges[name] unless memoized_badges[name].nil?
      alt_cond = self.class.badge_alt_callbacks[name]
      if_cond = self.class.badge_if_callbacks[name]
      unless_cond = self.class.badge_unless_callbacks[name]
      eval_cond = self.class.badge_callbacks[name]
      
      memoized_badges[name] ||= 
        ( alt_cond.call(self) || \
            (
              if (if_cond.nil? || 
                   (if_cond && if_cond.call(self))
                 )  && 
                 (unless_cond.nil? || 
                   (unless_cond && !unless_cond.call(self))
                 )
                  
                 eval_cond.call(self)

              else
                false
              end
            )
        )
    end

    protected
    
    def memoized_badges
      @memoized_badges ||= {}
    end

  end
  
end
