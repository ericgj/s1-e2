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
  
  task :badgeable => ['db:migrate', 'test:setup'] do
    load 'spec/unit/badgeable_spec.rb'
  end
  
  task :user_stat => ['db:migrate', 'test:setup'] do
    load 'spec/unit/user_stat_spec.rb'
  end
  
  task :user => ['db:migrate', 'test:setup'] do
    load 'spec/unit/user_spec.rb'
  end
  
  task :action => ['db:migrate', 'test:setup'] do
    load 'spec/unit/action_spec.rb'
  end
  
  task :unit => ['db:migrate', 'test:setup'] do
    puts "-----------------------\nUnit tests\n-----------------------"
    Dir['spec/unit/**/*.rb'].each {|f| load f; puts "-----"}
  end
  
  task :integration => ['db:migrate', 'test:setup'] do
    puts "-----------------------\nIntegration tests\n-----------------------"
  end
  
  task :all => ['db:migrate', 'test:setup'] do
    Rake::Task['test:unit'].execute
    Rake::Task['test:integration'].execute
  end
  
end
