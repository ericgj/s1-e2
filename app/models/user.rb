class User
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  
  has n, :actions
  has n, :repos
  has n, :stats, 'UserStat'
  
  def increment_stat(action_type)
#    unless stat = stats.first(:type => "#{action_type}Stat")
#      stats << (stat = UserStat.new({:type => "#{action_type}Stat"}))
#      stats.save
#    end
    s = stat(action_type)
    s.count += 1
    s.save
  end
  
  def stat(action_type)
    UserStat.first_or_create(:user_id => id, :type => "#{action_type}Stat")
  end
  
  def badges
    stats.all.inject([]) do |memo, stat|
      memo += stat.badges
      memo
    end
  end
  
end

