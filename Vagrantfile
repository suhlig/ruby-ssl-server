# frozen_string_literal: true

$script = <<SCRIPT
  apt-get install software-properties-common
  apt-add-repository ppa:brightbox/ruby-ng
  apt-get -y update
  apt-get -y install ruby2.4 ruby-switch
  ruby-switch --set ruby2.4
SCRIPT

Vagrant.configure('2') do |config|
  # https://atlas.hashicorp.com/search
  config.vm.box = 'ubuntu/trusty64'
  config.vm.provision 'shell', inline: $script

  # Xenial has an issue with shared folders...
  # config.vm.synced_folder ".", "/vagrant", :nfs => true
end
