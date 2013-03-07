# cpc

## Install

* Install Ruby 1.9.x and Gem
* `gem install bundler`
* `sudo apt-get install libsqlite3-dev`
* `bundle install`

## Commands
* cpc submit [contest] file...
* cpc submissions [user]
* cpc scoreboard [contest]
* cpc grade [contests]
* cpc contests [-a]
* cpc register
* cpc problems [contest]
* cpc help

## Directory Structure
```
[contest]/
   standings
   config.yaml -- Only used during initialization
   [problem]/
      problem.txt
      config.yaml -- Optional, only used during initialization
      tests/
         [testId].in
         [testId].out
      submissions/
         graded/
            [username].[submission #]/
               [user files]
         queued/
            [username]/
               [user files]

```


## DB Tables
* User: id, name, alias
* Problem: id, competitionId, name, alias, points, type?
* Contest: id, name, alias, start, end
* Submission: id, userId, problemId, time, status, executionTime, errorId, score


* Do users have to register to compete? Or just use the CSL login?
* Error table? Or just an enumeration/string?
* Where will contest and problem configuration options be saved?
* What configuration options will be available?
* What will the format of the config files look like?
