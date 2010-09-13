class UserStat
  include DataMapper::Resource
  
  property :count, Integer, :default => 0
  property :type, Discriminator
  
  belongs_to :user
  
  def self.badge(level, badge)
    unless badge.is_a?(Badge)
      badge = Badge.first_or_create(:name => badge)
    end
    (@badges ||= []) << [level, badge]
  end
  
  def self.assigned_badges_for_level(level)
    @badges.select {|p| p[0] <= level }.map {|q| q[1]}
  end
  
  def badges
    self.class.assigned_badges_for_level(count)
  end
  
end

class PushActionStat < UserStat
  badge 1, '1 push'
  badge 20, '20 pushes'
  badge 50, '50 pushes'
end

