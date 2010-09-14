class Action
  include DataMapper::Resource
  
  property :id, Serial
  property :type, Discriminator
  
  belongs_to :actor, 'User'
  has 1, :repo
  
  after :save, :update_stats
  
  def update_stats
    actor.increment_stat(type)
    # repo.increment_stat(type)   ## TODO for repo-specific stats
  end
  
end

# Follows base behavior == increment stat for actor 
class PushAction < Action
end

# In addition to base behavior, increment 'ForkedAction' stat for repo owner
# This will go away when we implement repo.increment_stat above
class ForkAction < Action
  def update_stats
    super
    repo.owner.increment_stat('ForkedAction')
  end
end