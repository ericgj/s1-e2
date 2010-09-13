
# Data model for Github acheivements system 
(See README.original for the details of this exercise.)

The requirements can be verified by running a test suite.  See below for details.


## Requirements

The models have been implemented in DataMapper.  The following DM gems are needed:

  - dm-core
  - dm-migrations
  - dm-sqlite-adapter
    
For running tests, you need 
  
  - bacon
  - mocha
  - baconmocha
  - dm-transactions  
  
  
## How to run the tests

    rake test:all
    

Note that for now (13 Sep), only unit tests have been created, and only for one type of static badge (push actions).

Integration tests are planned, as well as implementation of more static badge types and dynamic badge types.