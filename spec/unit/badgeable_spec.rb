require 'baconmocha'

#----- Dummy classes for testing

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

class DummyPrecondition
  extend Badgeable
  include Badgeable::InstanceMethods
  
  badge('1') {|t| true}
  badge('0') {|t| false}
  badge 'and', :if => Proc.new {|t| t.has_badge?('1') && t.has_badge?('0')}
  badge 'nor', :unless => Proc.new {|t| t.has_badge?('1') || t.has_badge?('0')}
  badge 'not and', :unless => Proc.new {|t| t.has_badge?('and') }
  
  badge 'xor', :if => Proc.new {|t| t.has_badge?('not and')},
               :unless => Proc.new {|t| t.has_badge?('nor')}
end

class DummyAltPrecondition
  extend Badgeable
  include Badgeable::InstanceMethods

  attr_accessor :level
  
  badge '50' do |t| 
    t.level >= 50
  end
  
  badge '20', :alt => Proc.new {|t| t.has_badge?('50')} do |t|
    t.level >= 20
  end
  
  badge '1', :alt => Proc.new {|t| t.has_badge?('20')} do |t|
    t.level >= 1
  end
  
end

#----- 


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
    
    describe 'memoization' do
    
      it 'should only call each badge proc at most once' do
        @subject = DummyDependentBadges.new
        @subject.switch = true
        @subject.class.badge_callbacks.each_key do |badge|
          @subject.class.badge_callbacks[badge].expects('call').at_most_once
        end
      end
      
    end
    
  end
  
  describe 'when test object has badges with preconditions' do
  
    describe 'memoization' do
    
      it 'should only call each badge proc at most once' do
        @subject = DummyPrecondition.new
        @subject.class.badge_callbacks.each_key do |badge|
          @subject.class.badge_callbacks[badge].expects('call').at_most_once.returns(true)
        end
        @subject.badges
      end
      
    end

    describe 'badge state' do
    
      before do
        @subject = DummyPrecondition.new
      end
      
      it 'should have badge 1' do
        @subject.badges.should.include('1')
      end
      
      it 'should not have badge 0' do
        @subject.badges.should.not.include('0')
      end
      
      it 'should not have badge \'and\'' do
        @subject.badges.should.not.include('and')
      end
    
      it 'should not have badge \'nor\'' do
        @subject.badges.should.not.include('nor')
      end
      
      it 'should have badge \'not and\'' do
        @subject.badges.should.include('not and')
      end
      
      it 'should have badge \'xor\'' do
        @subject.badges.should.include('xor')
      end
      
    end
  
    
  end

  describe 'when test object has badges with alt preconditions' do
  
    describe 'when test object level = 50' do
      before do
        Mocha::Mockery.reset_instance
        @subject = DummyAltPrecondition.new
        @subject.level = 50
      end
            
      it 'should only call the badge 50 proc, and call it only once' do
        @subject.class.badge_callbacks['1'].expects('call').never
        @subject.class.badge_callbacks['20'].expects('call').never
        @subject.class.badge_callbacks['50'].expects('call').once.returns(true)
        @subject.badges
      end
      
      it 'should have the 1, 20, and 50 badges' do
        @subject.badges.should.include('1')
        @subject.badges.should.include('20')
        @subject.badges.should.include('50')
      end
      
    end

    describe 'when test object level = 20' do
      before do
        Mocha::Mockery.reset_instance
        @subject = DummyAltPrecondition.new
        @subject.level = 20
      end
      
      it 'should only call the badge 20 and 50 procs, and call each only once' do
        @subject.class.badge_callbacks['1'].expects('call').never
        @subject.class.badge_callbacks['20'].expects('call').once.returns(true)
        @subject.class.badge_callbacks['50'].expects('call').once.returns(false)
        @subject.badges
      end
      
      it 'should have the 1, 20, but not the 50 badges' do
        @subject.badges.should.include('1')
        @subject.badges.should.include('20')
        @subject.badges.should.not.include('50')
      end
      
    end
    
    describe 'when test object level = 1' do
      before do
        Mocha::Mockery.reset_instance
        @subject = DummyAltPrecondition.new
        @subject.level = 1
      end
      
      it 'should call the badge 1, 20, and 50 procs, and call each only once' do
        @subject.class.badge_callbacks['1'].expects('call').once.returns(true)
        @subject.class.badge_callbacks['20'].expects('call').once.returns(false)
        @subject.class.badge_callbacks['50'].expects('call').once.returns(false)
        @subject.badges
      end
      
      it 'should have the 1 but not the 20 and 50 badges' do
        @subject.badges.should.include('1')
        @subject.badges.should.not.include('20')
        @subject.badges.should.not.include('50')
      end
      
    end
    
    describe 'when test object level = 0' do
      before do
        Mocha::Mockery.reset_instance
        @subject = DummyAltPrecondition.new
        @subject.level = 0
      end
      
      it 'should call the badge 1, 20, and 50 procs, and call each only once' do
        @subject.class.badge_callbacks['1'].expects('call').once.returns(false)
        @subject.class.badge_callbacks['20'].expects('call').once.returns(false)
        @subject.class.badge_callbacks['50'].expects('call').once.returns(false)
        @subject.badges
      end
      
      it 'should have no badges' do
        @subject.badges.should.not.include('1')
        @subject.badges.should.not.include('20')
        @subject.badges.should.not.include('50')
      end
      
    end
    
  end
  
  
end