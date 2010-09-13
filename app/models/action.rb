class Action
  include DataMapper::Resource
  
  property :id, Serial
  property :type, Discriminator
  
  belongs_to, :actor, 'User'
  has 1, :repo
  
  after :save, :update_stats
  
  def update_stats
    actor.increment_stat("#{type}Stat")
  end
  
end


class PushAction < Action
end

