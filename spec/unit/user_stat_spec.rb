#require 'mocha'
#require 'baconmocha'

## TODO pretty much all of this needs to move to user_spec

describe 'PushActionStat', 'badges' do
  
  BADGE_NAME_1 = 'Shorty'
  BADGE_NAME_20 = 'Homie'
  BADGE_NAME_50 = 'Gangsta'
  
  # doesn't work in bacon -- need monkeypatching
  let :dummy_user do
    x = User.new(:name => 'foo')
    x.save
    x  
  end
  
  shared 'having only 1st badge' do
    it 'should have one badge' do
      @subject.user.badges.size.should.eql 1
    end
    it 'should have the badge for 1 push' do
      @subject.user.badges[0].name.should.eql BADGE_NAME_1
    end  
  end
  
  shared 'having only 1st and 2nd badges' do
    it 'should have two badges' do
      @subject.user.badges.size.should.eql 2
    end
    it 'should have the badge for 1 push' do
      @subject.user.badges.map(&:name).should.include BADGE_NAME_1
    end  
    it 'should have the badge for 20 pushes' do
      @subject.user.badges.map(&:name).should.include BADGE_NAME_20
    end  
  end
  
  shared 'having 1st, 2nd, and 3rd badges' do
    it 'should have three badges' do
      @subject.user.badges.size.should.eql 3
    end
    it 'should have the badge for 1 push' do
      @subject.user.badges.map(&:name).should.include BADGE_NAME_1
    end  
    it 'should have the badge for 20 pushes' do
      @subject.user.badges.map(&:name).should.include BADGE_NAME_20
    end  
    it 'should have the badge for 50 pushes' do
      @subject.user.badges.map(&:name).should.include BADGE_NAME_50
    end  
  end
  
  
  describe 'initially' do
   
    it 'should have no badges' do
      @subject = PushActionStat.new(:user_id => dummy_user.id)
      @subject.user.badges.should.be.empty
    end
  end
  
  describe '1 action' do
    
    before do
      @subject = PushActionStat.new(:user_id => dummy_user.id)
      @subject.count = 1
    end
    
    behaves_like 'having only 1st badge'
  end
  
  describe '2 actions' do
    
    before do
      @subject = PushActionStat.new(:user_id => dummy_user.id)
      @subject.count = 2
    end
    
    behaves_like 'having only 1st badge'  
  end
  
  describe '19 actions' do
    
    before do
      @subject = PushActionStat.new(:user_id => dummy_user.id)
      @subject.count = 19
    end
    
    behaves_like 'having only 1st badge'  
  end
  
  describe '20 actions' do
    
    before do
      @subject = PushActionStat.new(:user_id => dummy_user.id)
      @subject.count = 20
    end
    
    behaves_like 'having only 1st and 2nd badges'  
  end

  describe '21 actions' do
    
    before do
      @subject = PushActionStat.new(:user_id => dummy_user.id)
      @subject.count = 21
    end
    
    behaves_like 'having only 1st and 2nd badges'  
  end
  
  describe '49 actions' do
    
    before do
      @subject = PushActionStat.new(:user_id => dummy_user.id)
      @subject.count = 49
    end
    
    behaves_like 'having only 1st and 2nd badges'  
  end
  
  describe '50 actions' do
    
    before do
      @subject = PushActionStat.new(:user_id => dummy_user.id)
      @subject.count = 50
    end
    
    behaves_like 'having 1st, 2nd, and 3rd badges'  
  end
  
  describe '51 actions' do
    
    before do
      @subject = PushActionStat.new(:user_id => dummy_user.id)
      @subject.count = 51
    end
    
    behaves_like 'having 1st, 2nd, and 3rd badges'  
  end
  
  describe '100 actions' do
    
    before do
      @subject = PushActionStat.new(:user_id => dummy_user.id)
      @subject.count = 100
    end
    
    behaves_like 'having 1st, 2nd, and 3rd badges'  
  end
  
end
