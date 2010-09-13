module Boot
  require 'rubygems'
  require 'dm-core'

  def self.connect(env)
    # connect to the dbase
    require File.join(File.dirname(__FILE__), 'environments', env.to_s)
  end
  
  def self.load
    # load the models
    Dir[File.join(File.dirname(__FILE__), '..', 'app', 'models', '*.rb')].each do |f|
      require f
    end
  end
  
  def self.migrate!
    require 'dm-migrations'

    # create tables based on models
    DataMapper.auto_migrate!
  end
  
  def self.finalize
    # check for validity and initialize relationships
    DataMapper.finalize
  end
  
end