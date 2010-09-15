
class Dummy
  extend Badgeable
  include Badgeable::InstanceMethods

  attr_accessor :name
  attr_accessor :count
  
  badge "For Being Eric" do |t|
    t.name == "Eric"
  end
  
  badge "Gold Star" do |t|
    t.count >= 50
  end
    
end

class DummyDefaultBadge
  extend Badgeable
  include Badgeable::InstanceMethods
  
  badge 'default'
  
end

class DummyDependentBadges
  extend Badgeable
  include Badgeable::InstanceMethods

  attr_accessor :switch
  
  badge('1') {|t| t.switch}
  badge('2') {|t| t.has_badge?('1')}
  badge('3') {|t| t.has_badge?('2') && t.has_badge?('1')}
  
end


describe 'Badgeable', '#badges' do

  describe 'when class defines a \'default\' badge without a block' do
  
    it 'test object should have the default badge' do
      @subject = DummyDefaultBadge.new
      @subject.badges.should.include 'default'
    end
  end
  
  describe 'when test object name is Eric and count is 0' do
  
    before do
      @subject = Dummy.new
      @subject.name = "Eric"
      @subject.count = 0
    end
    
    it 'should return array with one item' do
      @subject.badges.size.should.eql 1
    end
    
    it 'should include For Being Eric badge' do
      @subject.badges.should.include "For Being Eric"
    end
    
  end
  
  describe 'when test object name is nil and count is 50' do
  
    before do
      @subject = Dummy.new
      @subject.name = nil
      @subject.count = 50
    end
    
    it 'should return array with one item' do
      @subject.badges.size.should.eql 1
    end
    
    it 'should include Gold Star badge' do
      @subject.badges.should.include "Gold Star"
    end
    
  end
  
  describe 'when test object name is Eric and count is 51' do
  
    before do
      @subject = Dummy.new
      @subject.name = "Eric"
      @subject.count = 51
    end
    
    it 'should return array with two items' do
      @subject.badges.size.should.eql 2
    end
    
    it 'should include For Being Eric badge' do
      @subject.badges.should.include "For Being Eric"
    end
    
    it 'should include Gold Star badge' do
      @subject.badges.should.include "Gold Star"
    end
    
  end
  
  
  describe 'when test object has dependent badges' do
  
    describe 'when switch = true' do
      
      before do
        @subject = DummyDependentBadges.new
        @subject.switch = true
      end
      
      it 'should have badge 1' do
        @subject.badges.should.include('1')
      end
      
      it 'should have badge 2' do
        @subject.badges.should.include('2')
      end
      
      it 'should have badge 3' do
        @subject.badges.should.include('3')
      end
      
    end
    
    describe 'when switch = false' do
      
      before do
        @subject = DummyDependentBadges.new
        @subject.switch = false
      end
      
      it 'should not have badge 1' do
        @subject.badges.should.not.include('1')
      end
      
      it 'should not have badge 2' do
        @subject.badges.should.not.include('2')
      end
      
      it 'should not have badge 3' do
        @subject.badges.should.not.include('3')
      end
      
    end
    
  end
  
end