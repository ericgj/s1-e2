require 'rubygems'
require "bundler"
Bundler.setup(:default)

module App
  require 'dm-core'

  def self.connect(env)
    # connect to the dbase
    require File.join(File.dirname(__FILE__), 'environments', env.to_s)
  end
  
  def self.load
    # load lib
    Dir[File.join(File.dirname(__FILE__), '..', 'lib', '**', '*.rb')].each do |f|
      require f
    end
    
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

  def self.boot(env = 'test')
    connect(env)
    load
    finalize
  end
  
  def self.boot!(env = 'test')
    connect(env)
    load
    migrate!
    finalize
  end
  
end

