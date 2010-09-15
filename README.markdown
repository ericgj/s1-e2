
# Data model for Github acheivements system 
(See README.original for the details of this exercise.)

The requirements can be verified by running a test suite.  See below for details.

As of 13 Sep, four types of badges are implemented (all in relation to the user in general, not to a single repo):

- static, level-based badges for pushes
- static, level-based badges for forks
- static, level-based badges for having forked repo's
- dynamic ratings badge for top 10% in pushes


## Dependencies

The models have been implemented in DataMapper, and bacon was used for the tests.  See the Gemfile.lock file for details.

  
## How to run the tests

    rake test:all
    

Note that for now (13 Sep), only unit tests have been created.

Integration tests are planned, as well as implementation of more badge types and single-repo based badges.


## Basics of my 'badge DSL'

Any model -- not just the User -- that you want to collect stats on and determine one or more badges on the basis of these stats, simply needs to 

    extend Badgeable
    include Badgeable::InstanceMethods
    
This gives you, at the class level, a macro style method `badge` for defining badges on the basis of some other state:

    badge 'Cy Young' do |instance|
      # evaluate some state of the instance or its associates
      # when it returns true, the instance has the badge
    end
    
You can define as many badges as you like this way.

On the instance level, you get a method for evaluating a badge proc: `has_badge?`.  Note that the results of this evaluation are memoized.

You also get a default method for evaluating all the badge procs:  `badges`.  This returns an array of the current evaluated badges as strings (the strings used to identify the badges).

The User model wraps this #badges method and (among other things) converts the strings to Badge objects.

I found many advantages to separating out the `Badgeable` mechanics.  Unit testing, obviously, is easier.  

But also it makes it easier to deal with part of the problem I haven't tackled yet, which is _collecting stats and assigning badges to users on the basis of actions on single repo's they own_.  I anticipate in the future making the Repo model `Badgeable`, and expanding the User badges method to pull in badges from their repos, as well as from their own actions.

## Enhancements

The other proposed enhancement is to allow :if and :unless options when defining the badge conditions.  The idea is you could run a less-expensive proc first to check whether it is even possible that the user would have the badge, before running the (presumably more-expensive) badge evaluation.  

So for instance in the case of the 'Bad Mother Forker' badge you could do:

    badge 'Bad Mother Forker', 
          :unless => Proc.new {|u| u.repos.count < 50 } do |u|
      stat = u.stats.of_type('ForkActionStat')
      stat.count >= 50
    end

That is, if you have less than 50 repos anyway, you can't possibly have 50+ forks, and it's (maybe) easier to check a cached `repos.count` than to run `stats.of_type`.

Also, we could then evaluate one badge on the basis of another -- which was one of the points of this exercise:

    badge 'Beginner', :if => Proc.new {|u| u.has_badge?('Intermediate')}
    badge 'Intermediate', :if => Proc.new {|u| u.has_badge?('Advanced')}
    
This brings into focus the importance of memoizing the results of the badge evaluations.  That way, in this case, _regardless of which order the badges are evaluated_, the 'Intermediate' badge proc is only called once.
    
    
## Project evaluation

This was a great exercise, deceptively complicated as Greg put it (and more so the closer you look at it).

Initially I had considered simply using plain ruby objects rather than a ORM or other persistence library.  But my thought was this would be in fact _extra_ work, since for any real implementation you'd need to replace all this with persistence and SQL for crunching through thousands of users and repos.  Also how can you talk about optimization without considering that you are going to be dealing with a database (the slowest piece of the puzzle)?  

Anyway, I think using DM was not a bad choice (esp. with with an in-memory dbase for testing), looking back on it.  For one thing, it was useful to me to look at DataMapper which I hadn't used before.  It is nicer in a lot of ways than AR.  Although its ability to do aggregate queries with subqueries and other complex SQL is lacking (as in most ORMs).

Another thing I did was look at Bacon (with Mocha) for testing, a kind of stripped down RSpec.  I am hampered by learning RSpec before Test::Unit so I feel lost without the crutch of the RSpec style syntax.  Bacon's fine but makes you work a bit more than RSpec.  

I'd like to figure out how to wrap the tests (including the before and after) in a dbase transaction I can rollback, not sure if DM lets you do this very easily though.

