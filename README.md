cpc
===

Commands
---
* cpc submit [contest] file...
* cpc submissions [user]
* cpc scoreboard [contest]
* cpc grade [contests]
* cpc contests [-a]
* cpc register
* cpc problems [contest]
* cpc help

Directory Structure
---
```
[contest]/
   standings
   .config -- Only used during initialization
   [problem]/
      [problem].txt
      .config -- Only used during initialization
      tests/
         [testId].in
         [testId].out
      [username].[submission #]/
         [user files]
```


DB Tables
---
* User: id, name, alias
* Problem: id, competitionId, name, alias, points, type?
* Contest: id, name, alias, start, end
* Submission: id, userId, problemId, submissionTime, status, executionTime, errorId


* Do users have to register to compete? Or just use the CSL login?
* Error table? Or just an enumeration/string?
* Where will contest and problem configuration options be saved?
* What configuration options will be available?
* What will the format of the config files look like?
