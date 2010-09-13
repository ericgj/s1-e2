require 'bacon'
require 'dm-transactions'

describe 'User', 'increment_stat' do

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
