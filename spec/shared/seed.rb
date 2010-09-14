# firrst draft

module Seed
 
  def generate(spec = {})
    assocs = spec.delete_if { |k, v| Hash === v }
    it = self.class.model.new(spec)
    assocs.each_pair do |assoc, cond|
      klass = Object.const_get(assoc.to_s.constantize)
      it.__send__(assoc) = klass.first(cond)
    end
    yield(it) if block_given?
    it.save
  end
  
  def random
    max = self.class.model.all.last.count
    id = rand(max)
    self.class.model.all.find { |it| it.id == id }
  end
  
  class Action
    include Seed
    def self.model; ::Action; end
  end
  
  class Repo
    include See
    def self.model; ::Repo; end
  end
  
end
