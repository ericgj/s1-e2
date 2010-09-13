
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

describe 'Badgeable', '#badges' do

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
  
end