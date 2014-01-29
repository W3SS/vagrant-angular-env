# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Turn off shared folders
  # config.vm.synced_folder ".", "/vagrant", id: "vagrant-root", disabled: true

  # Begin dev server
  config.vm.define "dev", primary:true do |dev|

    dev.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end

    dev.vm.network :private_network, ip: "192.168.205.10"
    dev.vm.network :forwarded_port, guest: 3000, host: 3001
    dev.vm.network :forwarded_port, guest: 8000, host: 8001

    dev.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.module_path = "puppet/modules"
      puppet.manifest_file  = "default.pp"
    end
  end
  # End dev server

  # Begin protractor server
  config.vm.define "e2e" do |e2e|
    # config.vm.synced_folder "~/vagrant/dinner/src/test/e2e", "/dinner"
    
    e2e.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
    end

    e2e.vm.network :private_network, ip: "192.168.205.11"

    # Run an initial provisioning block that just updates the version of the
    # Chef client on the machine. We have to get up past 11.6.0 to support
    # environments with chef-solo.
    e2e.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "./chef/cookbooks"
      chef.run_list = [
        "recipe[chef_update]"
      ]
      chef.json = {
        "chef_update" => {
          "minimum_version" => {
            "major" => 11,
            "minor" => 6
          }
        }
      }
    end

    # Enable provisioning with chef solo, specifying a cookbooks path, roles
    # path, and data_bags path (all relative to this Vagrantfile), and adding
    # some recipes and/or roles.
    e2e.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "./chef/cookbooks"
      chef.roles_path = "./chef/roles"
      chef.environments_path = "./chef/environments"
      chef.environment = "local-vagrant"
      chef.add_role "protractor-selenium-server"
    end

  end
  # End protractor server

end
