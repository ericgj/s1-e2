require 'mocha'
require 'baconmocha'
require 'dm-transactions'

describe 'PushAction', 'save' do

  it 'should call #increment_stat on actor' do
    Action.transaction do |t|
      @subject = PushAction.new
      @actor = User.new
      @actor.expects(:increment_stat).with(@subject.type)
      @subject.actor = @actor
      @subject.save
      
      t.rollback
    end
  end
  
end
