require 'dm-aggregates'

class UserStat
  include DataMapper::Resource
  extend Badgeable
  include Badgeable::InstanceMethods
  
  property :id, Serial
  property :count, Integer, :default => 0
  property :type, Discriminator
  
  belongs_to :user
    
  # sugar for defining level badges
  def self.level_badge(name, level = 1)
    badge(name) do |s|
      s.count >= level
    end
  end
  
  #----- these below can be used as association predicates
  
  def self.of_type(t)
    all(:type => t.to_s)
  end
  
  # possibly redo this as straight SQL instead of 2 queries
  # DM's aggregate functions are limited in what they allow you to do
  def self.top_pct(pct = 10)
    cnts = aggregate(:count.sum, :fields => [:user_id]).
              sort {|p| p[1]}.
              reverse
    ids = cnts[0..(((cnts.size * (pct/100)).to_i)-1)].map {|pair| pair[0]}
    all(:user_id => ids)
  end
  
  # possibly redo this as straight SQL instead of 2 queries
  # DM's aggregate functions are limited in what they allow you to do
  def self.top_n(num = 10)
    cnts = aggregate(:count.sum, :fields => [:user_id]).
              sort {|p| p[1]}.
              reverse
    ids = cnts[0..num].map {|pair| pair[0]}
    all(:user_id => ids)
  end
  
end

# UserStat subclasses

class PushActionStat < UserStat
  level_badge 'Shorty', 1
  level_badge 'Homie', 20
  level_badge 'Gangsta', 50
end

class ForkActionStat < UserStat
  level_badge 'Spooner', 1
  level_badge 'Forker', 20
  level_badge 'Bad Mother Forker', 50
end

class ForkedActionStat < UserStat
  level_badge 'Forked Dork', 1
  level_badge 'Forked Pork', 20
  level_badge 'Forked Zork', 50
end

