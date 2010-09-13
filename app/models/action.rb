class Action
  include DataMapper::Resource
  
  property :id, Serial
  property :type, Discriminator
  
  belongs_to :actor, 'User'
  has 1, :repo
  
  after :save, :update_stats
  
  def update_stats
    actor.increment_stat(type)
  end
  
end


class PushAction < Action
end

class ForkAction < Action
  def update_stats
    super
    repo.owner.increment_stat('ForkedAction')
  end
end