# packer
---

This repo builds a Vagrant CentOS 7 box from scratch using Kickstart and an
.iso file.

### Requirements
* VirtualBox
* VirtualBox Extension Pack
* Vagrant for your system - [http://vagrantup.com/](http://vagrantup.com)
* Vagrant vbplugin
* Packer for your system - script included in this repo
* Ansible for your system - `pip` installable

### Customization
* Put the public SSH key you wish to use into the following locations:
  * `vagrant/http/ks.cfg`
  * `ansible/assets/ssh/vagrant_rsa_authkeys`
* Edit `ansible/vagrant_devbox.yml` and put in the non-`vagrant` username you wish to use. I don't like running with the default `vagrant` user, so this project is set up to create a user just for me where I can do all the customizations I want. Eventually I will eliminate `vagrant` altogether and just roll with my chosen user. 

### Building from scratch with Packer
* Install prereqs above
* After installing Vagrant, install the VirtualBox vbguest plugin: `vagrant plugin install vagrant-vbguest`
* Run `install_packer.sh` to install Packer to `/usr/local/bin`
* Change to `vagrant/` and make any necessary adjustments to configs (like to
`centos7_vars.json`, for example
* Acquire the CentOS ISO referenced in var files and make sure it's in the `resources/` directory. You can use the included `get_centos7.sh` script to grab it.
* Run `packer validate -var-file centos7_vars.json centos7.json`
* Run `packer build -var-file centos7_vars.json centos7.json`

### Creating and Using the Vagrant Box
* The `.box` file will appear in `boxout/` when Packer is finished. You can then
add it to Vagrant like so:  
    `vagrant box add <name> "file:///<path_to_this_repo>/vagrant/boxout/centos-7-x64-virtualbox-minimal.box"`
* Configure your Vagrantfile. An example is given in this repo, but you'll need to adjust paths, box name, VM name, etc.
* Copy your `Vagrantfile` to the location where you'll create/manage the Vagrant box; alternatively, create your own
* Configure the `local_user` variable in `ansible/vagrant_devbox.yml`
* `vagrant up` to create the Vagrant box
* Check output to make sure the VirtualBox Guest Additions are installed correctly, which should happen automatically. These must be in place for the default `/vagrant` share to be established.
* Ansible provisioning should happen after the box is created and mounts are established.

### Troubleshooting
* If you run into issues with Guest Additions, check that you have the `vagrant-vbguest` plugin installed: `vagrant plugin list`
* To re-run any customizations after you're up and going - such as after Ansible edits - just run `vagrant provision`.
* To use the non-`vagrant` local user you created, update the `config.ssh.username` parameter in your `Vagrantfile`
