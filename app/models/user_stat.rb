class UserStat
  include DataMapper::Resource
  
  property :id, Serial
  property :count, Integer, :default => 0
  property :type, Discriminator
  
  belongs_to :user
  
  # these can be used as association predicates
  def of_type(t)
    all(:type => t.to_s)
  end
  
  def top_pct(pct = 10)
    cnts = aggregate(:count.sum, :fields => [:user_id]).
              sort {|p| p[1]}.
              reverse
    ids = cnts[0..(((cnts.size * (pct/100)).to_i)-1)].map {|pair| pair[0]}
    all(:user_id => ids)
  end
  
  def top_n(num = 10)
    cnts = aggregate(:count.sum, :fields => [:user_id]).
              sort {|p| p[1]}.
              reverse
    ids = cnts[0..num].map {|pair| pair[0]}
    all(:user_id => ids)
  end
  
end

# UserStat subclasses

class PushActionStat < UserStat
end

__END__

class ForkActionStat < UserStat
  badge 1, 'Spooner'
  badge 20, 'Forker'
  badge 50, 'Bad Mother Forker'
end

class ForkedActionStat < UserStat
  badge 1, 'Forked Dork'
  badge 20, 'Forked Pork'
  badge 50, 'Forked Zork'
end

