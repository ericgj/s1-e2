 DataMapper::Logger.new($stdout, :info)
 DataMapper.setup(:default, 'sqlite::memory:')