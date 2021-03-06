class Repo
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  
  belongs_to :owner, 'User'
  
end