# Ruby Playoff Bracket Simulator

### Purpose

This is a hobby project for demonstrating how I would write code, if left to my
own vices. Inspired by my Dad's double elimination bracket in Excel, I wanted
to see if it could be done in Ruby, in the console, not that it should... Of
course it could be done. Anything is possible. It proved to be more challenging
than I expected, which made it fun.

### Requirements

* Tested with Ruby 3.3.0

### Try It Out

* Clone the repo
* From the root folder:
```
$ ./bin/bracket create -b tourney_name -t ./data/teams/teams_ex.yaml
$ ./bin/bracket simulate -b tourney_name
$ ./bin/bracket show -b tourney_name
```

##### Example Results
![example output of show command](/ex_sim.png)

### TODO List (should I decide to take it further)

* Handle erroneous user input in the update function
* Clean up TODOs in the application
* Think about refactoring, drawing the lines is complicated/inefficient
* Support Byes
* Enforce at least an even number of teams, if not a power of 2
* Be able to handle rounds going off the right edge of the screen
* Support double elimination

### Questions

* Should we limit team names to a certain number of characters?
* Should we limit the number of teams? 32 might be a good max?
