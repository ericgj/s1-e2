$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

namespace :db do

  # Note: always run db:migrate vs db:load if you are using an in-memory dbase
  # as we are in the testing environment
  
  task :migrate do
    require 'config/boot'
    Boot.connect('test')
    Boot.load
    Boot.migrate!
    Boot.finalize
  end
  
  task :load do
    require 'config/boot'
    Boot.connect('test')
    Boot.load
    Boot.finalize
  end
  
end

namespace :test do
  
  task :setup do
    require 'bacon'
    #Bacon.extend Bacon::TestUnitOutput
    Bacon.summary_on_exit
  end
  
  task :user_stat => ['db:migrate', 'test:setup'] do
    load 'spec/user_stat_spec.rb'
  end
  
  task :user => ['db:migrate', 'test:setup'] do
    load 'spec/user_spec.rb'
  end
  
  task :action => ['db:migrate', 'test:setup'] do
    load 'spec/action_spec.rb'
  end
  
  task :all => ['db:migrate', 'test:setup'] do
    Rake::Task['test:user_stat'].execute
    Rake::Task['test:user'].execute
    Rake::Task['test:action'].execute
  end
  
end
