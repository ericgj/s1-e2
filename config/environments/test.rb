 DataMapper::Logger.new(File.join(File.dirname(__FILE__), '..', '..', 'log', 'test.log'), :debug)
 DataMapper.setup(:default, 'sqlite::memory:')