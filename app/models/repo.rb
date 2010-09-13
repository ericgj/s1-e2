class Repo
  include DataMapper::Resource
  
  belongs_to :owner, 'User'
  
end