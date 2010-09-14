$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

namespace :test do
  
  task :boot do
    require 'config/app'
    App.boot!('test')
  end
  
  task :setup do
    require 'bacon'
    #Bacon.extend Bacon::TestUnitOutput
    Bacon.summary_on_exit
  end
  
  task :badgeable => ['test:boot', 'test:setup'] do
    load 'spec/unit/badgeable_spec.rb'
  end
  
  task :user_stat => ['test:boot', 'test:setup'] do
    load 'spec/unit/user_stat_spec.rb'
  end
  
  task :user => ['test:boot', 'test:setup'] do
    load 'spec/unit/user_spec.rb'
  end
  
  task :action => ['test:boot', 'test:setup'] do
    load 'spec/unit/action_spec.rb'
  end
  
  task :unit => ['test:boot', 'test:setup'] do
    puts "-----------------------\nUnit tests\n-----------------------"
    Dir['spec/unit/**/*.rb'].each {|f| load f; puts "-----"}
  end
  
  task :integration => ['test:boot', 'test:setup'] do
    puts "-----------------------\nIntegration tests\n-----------------------"
    Dir['spec/integration/**/*.rb'].each {|f| load f; puts "-----"}
  end
  
  task :all => ['test:boot', 'test:setup'] do
    Rake::Task['test:unit'].execute
    Rake::Task['test:integration'].execute
  end
  
end
