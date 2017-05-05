Mongo db configuration
==================

URI format for Single-node plan:
```
mongodb://dbuser:dbpass@host:port/dbname
```

URI format for Cluster plan:
```
mongodb://dbuser:dbpass@host1:port1,host2:port2/dbname
```

The configuration fo the mongoDB connection could be found at
test/mongoid.yml

Tests
===

To run a single test, just do:

```
ruby -I . -I test/helper test/state_test.rb --name /database.operations/
```

CLI App
=======

Running: `ruby app/cli3.rb [command]`

To see full StackTrace:  `GLI_DEBUG=true ruby app/cli3.rb [command]`

GUARD
=====

Running guard: `guard`, `guard -c`(this options clears the prompt before
every test run)

* `[enter]` in guard prompt -> run all tests
* `pause` in guard prompt -> stop watching files

PRY
===

Use it as command-line: `pry`

Use it as debugger: `binding.pry` in code

Useful commands:

* `continue #debugger`
* `next #debugger`
* `exit #if debugging, continues, else, le`ave pry prompt
* `show-source Device#initialize`
* `edit Device#initialize`
* `ls -I @device #lists instances variable`s on @device
* `watch @device.state_machine.current_sta`te #add an expression to 'watch', it will tell you when it changes
* `watch #show all watches and their curre`nt values
* `help`
* `whereami #shows which line you are and `the code surrounding it
* `edit -c #edits the `whereami` location!`

Vagrant Customizations
===================

* Vim with Janus
* Vim Tmux Navigator(C-h, C-j, C-k, C-l navigates between Tmux Panes and
  also Vim splits
* Bash aliases, see: `vagrantfiles/bash_aliases`

KNOWN ISSUES
===========

* We're using gem `sourcify` in the lib/ProcSerializer utility, this gem
is old, unsuported and could cause us problems. We've documented known
problems in the "bugs" section of it's test and decided not to switch
off of it for the moment because maybe the feature of Storing/Restoring
procs/lambdas will be more of a Development helper. If it gets
problematic we'll move to either only using Validations/Operations
defined in classes, or switch the implementation to other gems:
ruby2ruby, seattlerb/ruby_parser, whitequark/parser
