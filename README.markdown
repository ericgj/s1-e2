
# Data model for Github acheivements system 
(See README.original for the details of this exercise.)

The requirements can be verified by running a test suite.  See below for details.

As of 13 Sep, four types of badges are implemented (all in relation to the user in general, not to a single repo):

- static, level-based badges for pushes
- static, level-based badges for forks
- static, level-based badges for having forked repo's
- dynamic ratings badge for top 10% in pushes


## Dependencies

The models have been implemented in DataMapper.  The following DM gems are needed:

  - dm-core
  - dm-migrations
  - dm-aggregates
  - dm-sqlite-adapter
    
For running tests, you need 
  
  - bacon
  - mocha
  - baconmocha
  - dm-transactions  
  
  
## How to run the tests

    rake test:all
    

Note that for now (13 Sep), only unit tests have been created.

Integration tests are planned, as well as implementation of more badge types and single-repo based badges.


## Project evaluation

This was a great exercise, deceptively complicated as Greg put it (and more so the closer you look at it).

Initially I had considered simply using plain ruby objects rather than a ORM or other persistence library.  But my thought was this would be in fact _extra_ work, since for any real implementation you'd need to replace all this with persistence and SQL for crunching through thousands of users and repos.  Also how can you talk about optimization without considering that you are going to be dealing with a database (the slowest piece of the puzzle)?  

Anyway, I think using DM with an in-memory dbase was not a bad choice, looking back on it.  For one thing, it was useful to me to look at DataMapper which I hadn't used before.  It is nicer in a lot of ways than AR.  Although its ability to do aggregate queries with subqueries and other complex SQL is lacking (as in most ORMs).

Another thing I did was look at Bacon (with Mocha) for testing, a kind of stripped down RSpec.  I am hampered by learning RSpec before Test::Unit so I feel lost without the crutch of the RSpec style syntax.  Bacon's fine but needs some tweaking -- for instance how to wrap the examples in rolled-back dbase transactions.

