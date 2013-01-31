cpc
===

Commands
---
cpc submit [contestId] file...
cpc submissions [user]
cpc leaderboard [contestId]
cpc grade [contests]



Directory Structure
---
```
[Contest]/
   standings
   .config -- Only used during initialization
   [Problems]/
      .pass
      .fail
      .queue
      .in
      .out
      .timestamps
      [Username].[Submission Number]/
         [user files]
```
