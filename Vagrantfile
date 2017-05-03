# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.ssh.forward_agent = true
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
   config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "../", "/home/vagrant/workspace/"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  #
  # NOTE: Commands to run as root
  config.vm.provision "shell", inline: <<-SHELL
    echo 'Running root setup'
    apt-get update
    apt-get install -y git wget htop vim curl mongodb-server
  SHELL
    #NOTE: if running local must update mongoid.yml file

  #NOTE: Commands to run as vagrant user
  config.vm.provision "shell", privileged: false,  inline: <<-SHELL
    echo 'Running vagrant user setup'
    # Install RVM
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    curl -sSL https://get.rvm.io | bash -s $1 
    source $HOME/.rvm/scripts/rvm || source /etc/profile.d/rvm.sh

    # Install Ruby and set it as default
    rvm install ruby-2.4

    # Optional: Create a gemset just for the dashboard
    # rvm gemset create dashboard
    # rvm gemset use dashboard

    # Install rails 5
    #gem install rails --version 5.0.1 --no-ri --no-rdoc

    # create your personal key for gitlab
    # TODO: BRENO: force user to define email variable before this step?
    #echo "ssh-keygen -t rsa -C <youremail>@avixy.com"
    #ssh-keygen -t rsa -C default@avixy.com

    # download project from gitlab
    # git clone <project address>

    # optionally create a gemset and configure minitests
    rvm gemset create minitest
    rvm gemset use minitest
    gem install minitest --no-ri --no-rdoc
    gem install bundler --no-ri --no-rdoc

    # install janus
    curl -L https://bit.ly/janus-bootstrap | bash
  SHELL

  # Send config files to VM
  config.vm.provision "file", source: './vagrantfiles/.bashrc', destination: '~/.bashrc'
  config.vm.provision "file", source: './vagrantfiles/.vimrc', destination: '~/.vimrc'
  config.vm.provision "file", source: './vagrantfiles/.vimrc.after', destination: '~/.vimrc.after'
  config.vm.provision "file", source: './vagrantfiles/.tmux.conf', destination: '~/.tmux.conf'
  config.vm.provision "file", source: './vagrantfiles/.bash_aliases', destination: '~/.bash_aliases'
  config.vm.provision "file", source: './vagrantfiles/.pryrc', destination: '~/.pryrc'

  #aditional vim config
  config.vm.provision "shell", privileged: false,  inline: <<-SHELL
    mkdir ~/.janus
    git clone https://github.com/christoomey/vim-tmux-navigator ~/.janus/vim-tmux-navigator
  SHELL
end
