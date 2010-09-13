class User
  include DataMapper::Resource
  extend Badgeable
  include Badgeable::InstanceMethods
  
  property :id, Serial
  property :name, String
  
  has n, :actions
  has n, :repos
  has n, :stats, 'UserStat'
  
  def self.level_badge(name, level = 1, klass = 'UserStat', &blk)
    badge name do |u|
      u.stats.of_type(klass).count >= level
    end
  end
  
  badge 'Top 10% pusher' do |u| 
    stats = PushActionStat.top_pct(10)
    stats.all.map(&:user_id).include?(u.id)
  end
    
  level_badge 'Shorty', 1, 'PushActionStat'
  level_badge 'Homie', 20, 'PushActionStat'
  level_badge 'Gangsta', 50, 'PushActionStat'

  def increment_stat(action_type)
    s = stat(action_type)
    s.count += 1
    s.save
  end
  
  def stat(action_type)
    UserStat.first_or_create(:user_id => id, :type => "#{action_type}Stat")
  end 
  
end

