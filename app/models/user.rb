class User
  include DataMapper::Resource
  
  has n, :actions
  has n, :repos
  has n, :stats, 'UserStat'
  
  def increment_stat(action_type)
    unless stat = stats.first(:type => action_type)
      stats << (stat = UserStat.new({:type => action_type}))
      stats.save
    end
    stat.count += 1
    stat.save
  end
  
  def badges
    stats.all.inject([]) do |memo, stat|
      memo += stat.badges
      memo
    end
  end
  
end

