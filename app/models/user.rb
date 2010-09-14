class User
  include DataMapper::Resource
  extend Badgeable
  include Badgeable::InstanceMethods
  
  property :id, Serial
  property :name, String
  
  has n, :actions
  has n, :repos
  has n, :stats, 'UserStat'
  
  #---- dynamic badge definitions
  #---- note that static (level) badges are defined in UserStat subclasses
  badge 'Top 10% pusher' do |u| 
    stats = PushActionStat.top_pct(10)
    stats.all.map(&:user_id).include?(u.id)
  end

  # A bit cryptic, basically this evaluates all the badges defined here
  # and adds to this the badges defined in the UserStats
  # and then builds Badge objects based on the strings returned
  alias_method :badges_original, :badges
  def badges
    stats.all.inject(badges_original) do |memo, s| 
      memo += s.badges
    end.map do |name|
      Badge.first_or_create(:name => name)
    end
  end
  
  #---- called in Action after
  def increment_stat(action_type)
    s = stat(action_type)
    s.count += 1
    s.save
  end
  
  def stat(action_type)
    UserStat.first_or_create(:user_id => id, :type => "#{action_type}Stat")
  end 
  
end

