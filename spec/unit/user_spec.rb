require 'bacon'
require 'dm-transactions'

describe 'User', '#increment_stat' do

  describe 'when stat record has not been created' do
    
    it 'the stat record count should be 1' do
      
      User.transaction do |t|
        @transaction = t
        @subject = User.new
        @subject.save
        @subject.increment_stat('PushAction')
        
        @subject.stat('PushAction').count.should.eql 1
        
        t.rollback
      end
    end
        
  end
  
  describe 'when stat record already exists' do

    it 'the stat record count should be +1' do
      User.transaction do |t|
        @initial_count = 50
        @initial_stat = PushActionStat.new(:count => @initial_count)
        @subject = User.new
        @subject.stats << @initial_stat
        @initial_stat.save
        @subject.save
        @subject.increment_stat('PushAction')
        
        @subject.stat('PushAction').count.should.eql(@initial_count + 1)
        
        t.rollback
      end
    end
        
  end
  
end

describe 'User', '#badges' do

  describe 'initially' do
  
    it 'should be empty' do
      User.transaction do |t|
        @subject = User.new
        
        @subject.badges.should.be.empty
        
        t.rollback
      end
    end
    
  end
  
  describe 'when push action count = 1 and no other users' do
  
    @setup_stats = Proc.new do |count|
                    @initial_stat = PushActionStat.new(:count => count)
                    @subject = User.new
                    @subject.stats << @initial_stat
                    @initial_stat.save
                    @subject.save
                  end
                  
    it 'should return 2 badges' do
      User.transaction do |t|
        @setup_stats.call(1)
        
        @subject.badges.size.should.eql 2
        
        t.rollback
      end
    end
    
    it 'each badge should be a Badge object' do
      User.transaction do |t|
        @setup_stats.call(1)
        
        @subject.badges.each {|b| b.class.should.eql Badge}
        
        t.rollback
      end
    end
    
    it 'should return a \'Shorty\' badge' do
      User.transaction do |t|
        @setup_stats.call(1)
        
        @subject.badges.map(&:name).should.include 'Shorty'
        
        t.rollback
      end
    end
    
    it 'should return a \'Top 10% pusher\' badge' do
      User.transaction do |t|
        @setup_stats.call(1)
        
        @subject.badges.map(&:name).should.include 'Top 10% pusher'
        
        t.rollback
      end
    end
    
  end
  
  describe 'when push action count = 100 and no other users' do
  
    @setup_stats = Proc.new do |count|
                    @initial_stat = PushActionStat.new(:count => count)
                    @subject = User.new
                    @subject.stats << @initial_stat
                    @initial_stat.save
                    @subject.save
                  end
                  
    it 'should return 4 badges' do
      User.transaction do |t|
        @setup_stats.call(100)
        
        @subject.badges.size.should.eql 4
        
        t.rollback
      end
    end
    
    it 'each badge should be a Badge object' do
      User.transaction do |t|
        @setup_stats.call(100)
        
        @subject.badges.each {|b| b.class.should.eql Badge}
        
        t.rollback
      end
    end
    
    it 'should return a \'Shorty\' badge' do
      User.transaction do |t|
        @setup_stats.call(100)
        
        @subject.badges.map(&:name).should.include 'Shorty'
        
        t.rollback
      end
    end
    
    it 'should return a \'Homie\' badge' do
      User.transaction do |t|
        @setup_stats.call(100)
        
        @subject.badges.map(&:name).should.include 'Homie'
        
        t.rollback
      end
    end
    
    it 'should return a \'Gangsta\' badge' do
      User.transaction do |t|
        @setup_stats.call(100)
        
        @subject.badges.map(&:name).should.include 'Gangsta'
        
        t.rollback
      end
    end
    
    it 'should return a \'Top 10% pusher\' badge' do
      User.transaction do |t|
        @setup_stats.call(100)
        
        @subject.badges.map(&:name).should.include 'Top 10% pusher'
        
        t.rollback
      end
    end
    
  end
  
  describe 'when push action count = 1 and fork action count = 1 and no other users' do
  
    @setup_stats = Proc.new do |count|
                    (@initial_stats = []) << PushActionStat.new(:count => count)
                    @initial_stats << ForkActionStat.new(:count => count)
                    @subject = User.new
                    @initial_stats.each {|s| @subject.stats << s; s.save}
                    @subject.save
                  end
                  
    it 'should return 3 badges' do
      User.transaction do |t|
        @setup_stats.call(1)
        
        @subject.badges.size.should.eql 3
        
        t.rollback
      end
    end
    
    it 'each badge should be a Badge object' do
      User.transaction do |t|
        @setup_stats.call(1)
        
        @subject.badges.each {|b| b.class.should.eql Badge}
        
        t.rollback
      end
    end
    
    it 'should return a \'Shorty\' badge' do
      User.transaction do |t|
        @setup_stats.call(1)
        
        @subject.badges.map(&:name).should.include 'Shorty'
        
        t.rollback
      end
    end
    
    it 'should return a \'Spooner\' badge' do
      User.transaction do |t|
        @setup_stats.call(1)
        
        @subject.badges.map(&:name).should.include 'Spooner'
        
        t.rollback
      end
    end
    
    it 'should return a \'Top 10% pusher\' badge' do
      User.transaction do |t|
        @setup_stats.call(1)
        
        @subject.badges.map(&:name).should.include 'Top 10% pusher'
        
        t.rollback
      end
    end
    
  end
  
end

