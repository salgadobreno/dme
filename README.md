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

Sinatra and React
===================

###Pre-requisites

- yarn
- node

------------------------------
### Running
* Run JSON Server for dev:
  `yarn api`
* Run React components in 'dev mode'(webpack js devserver, hot reload):
  `yarn dev`
* Run both!
  `yarn api | yarn dev`
* Build React components, update app/web/public/*-bundle.js files and make it
  available for Sinatra App:
  `yarn build`
* Build React components, update app/web/public*-bundle.js files and
  make it available for Production App:
  `yarn prod`
* Run Sinatra App:
  `ruby app/web/app.rb` or `rackup`

#### Attention!

> The `API URL` will be different depending on what environment you're in or what you're trying to do. When running React devserver normally you'll be using json-server as the API, so the default `API_URL` there is set, in `webpack.config.js`, to `http://localhost:8080`. When you run `yarn build` it will use the `webpack.prod.config.js`, which sets `API_URL` to `http://localhost:4567`. You can override the `API_URL` with an environment variable(normally sent along with the command) like: 
> `__API__='http://192.168.1.53:4567' yarn dev`
> `__API__='http://192.168.2.5:6060' yarn api | yarn api`
> `__API__='http://192.168.2.5:6060' yarn build && rackup`

#### Attention2!

> If you're working remotely through VPN you may need to pass additional parameters to access the server.
> `yarn dev --host 0.0.0.0`
> `ruby -I . app/web/app.rb -o 0.0.0.0`

CLI App
=======

Running: `ruby app/cli3.rb [command]`

To see full StackTrace:  `GLI_DEBUG=true ruby app/cli3.rb [command]`

APP RUNNER
==========

Running: `ruby -I . app/app_runner.rb -W0` (-W0 tries to supress
warnings)

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
* `watch @device.state_machine.current_sta`te #add an expression to
  'watch', it will tell you when it changes
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

Docker configuration
===
In order to use docker as a tool for development, test and deploy in the
production environment, some actions should be performed to make
everything work smothly.

* you need the docker environment installed on your machine. Please
  refer to https://docs.docker.com/engine/installation/

To make everything work you need:

1 - build the development container with ruby 2.4.1
2 - pull the mongoid container
3 - create a private network for the containers to share
4 - start the mongodb container using the private network created on the
previous step

## Build the development container

```
docker build .
```

* you can give a name for your development container and use it in you
  docker file to avoid forced unecessary builds.

eg. docker build -t company/name:tag

```
docker build -t avixy/maintenanceservice:0.1
```

## Pull the mongoid container

```
docker pull mongo
```

This will pull the latest version of the mongo container

## Create a local private network

```
docker network create --driver bridge my_nw
```

Please read:
https://docs.docker.com/engine/userguide/networking/#user-defined-networks

## Start the mongodb container using a existing network

```
docker run --network=my_nw -d --name=mongodb mongo
```

## Run tests

```
docker run <container_id or name> rake 
```

## BONUS:

To run a sinatra API test just run the container with this option:
```
docker run --network=my_nw ruby -p 8080:4567 app/api_service.rb
```

To make the container be removed after running do this:
```
docker run --rm --network=my_nw -p 8080:4567 09cedce91b94 ruby
app/api_service.rb
```

To clear unused containers, images and networs do:
```
docker system prune
```

# Using docker-compose to run your environment

I have added a docker compose file to help the deployment of this
application, but it can also be used to the development environment.

## To run and build the environment
```
docker-compose -f docker-compose.yml up -d --build -d
```

This will make the mongo container running and will run the application
tests. You could see the test result by running `docker logs` or
re-running the service docker container with the rake instruction
enabled:

```
docker run --network=devicemanagementengine_default --rm -it --env
RACK_ENV=test avixy/maintenancesrv:0.1 rake
```

You could use docker-compose command to run the service vm, just
remember to set the network between the containers.

At the end of the development session run `docker compose down` to shut
down all containers, networks and volumes created by the docker-compose
command.

Production deployment
===

To deploy this project into production you should use the docker-machine
application (https://docs.docker.com/machine/install-machine/):

- Install docker into the production host if needed
- Configure your local docker machine to map the production host using a
  generic driver
- Use the docker-compose-production.yml file as the configuration base
  for your deployment
- Be sure you have pair of pub/priv key in your local machine

First of all, you have to copy the public key to remote-host.
```
ssh-copy-id -i ~/.ssh/id_rsa.pub <remote-host - in this case 192.168.2.5>
```

There's a script create in order to make it smooth and is
located at 'scripts/deploy.sh'.

First this script checks if there's a mapping the production host in ur local
machine:
```
(sudo docker-machine ls -q | grep '^vm$')
```

Then it updates React Bundle Resources showed above:
```
(cd ../ && exec yarn prod)
```

After that, if the environment doesnt have the production host mapping
it creates it locally:
```
docker-machine create \
   --driver generic \
   --generic-ip-address=192.168.2.5 \
   --generic-ssh-key $KEY_FILE \
   --generic-ssh-user avixy vm
```

Finaly it deploys the application in the proper production container
```
docker-compose -f docker-compose-production.yml up --build -d
```

This should bring everything that you need to the production host

You can check the status of your machine with the command:
```
sudo docker-machine ls
```

There's also a Rake task to do all above procedures in once. Check it
out:

```
rake deploy[key_file]
```

That key_file parameter is a rsa key that need to be on server in order
to allow access to production server.

Running this task as super user, it brings on what u need and deploy
what production server needs.

GIT HOOKS
===

In order to not miss any TODO comments in src code, there's script
"todo_finder.sh" that
was mapped to a Rake Task :

```
rake todo
```

This script generates todo.txt file and outputs to screen lines that
contains TODO comments.

In order to update that todo.txt file for development, it was created
also a git hook "pre-commit" located in scripts folder.

Is recomended to create symbolic link inside .git folder to every
commit so that todo.txt file could be updated.

```
ln -s scripts/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```


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

