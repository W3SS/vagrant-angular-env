vagrant-angular-env
===================

Vagrant, puppet and chef files to create an Angular environment

These files stand up two virtual machines - one to host the development of AngularJS code and the other to host a Selenium instance for running headless e2e tests.

The development server comes with:
* NodeJS
* Ruby
* Git
* Yeoman
* Bower
* Grunt
* Protractor
* Compass
* PhantomJS

The e2e server comes with:
* Protractor
* Selenium Standalone Server
* Xvfb
* Chromium
* FireFox
* PhantomJS

The e2e server is 100% the work of [exratione](https://www.exratione.com/2013/12/angularjs-headless-end-to-end-testing-with-protractor-and-selenium/) and the source for it can be found [here](https://github.com/exratione/protractor-selenium-server-cookbook)

Assumes:
--------
* Vagrant
* VirtualBox
* Librarian-Chef

(See below for details on how to install these items)

Instructions For Use
---
1. Clone this repository

	git clone git@github.com:julliette/vagrant-angular-env.git
	
2. Navigate into the created folder

	cd vagrant-angular-env
	
3. Init the submodules

	git submodule init
	git submodule update
	
4. Navigate into the chef folder

	cd chef
	
5. Install the chef cookbooks for the e2e box

	librarian-chef install

You're ready to roll! Now you can bring up the boxes:

	vagrant up
or, if you only want one of the boxes:

	vagrant up dev

	vagrant up e2e
and then, to access the box:

	vagrant ssh dev

If either box gives you trouble with tools not being installed that should, try re-provisioning them before filing a bug:

	vagrant provision <machine name>

If you experience issues with Windows
---
if there’s an error message when you login:

	-bash: /etc/profile.d/nodejs.sh: line 10: syntax error: unexpected end of file

The issue is that the line endings are for Windows files (either done by git or puppet when generating this .sh file) and Ubuntu can’t understand them. To clean the line endings out:

	sudo apt-get install tofrodos
	sudo fromdos /etc/profile.d/nodejs.sh
	
and then logout and log back in. The error should be gone.

Supporting Tools Installation
----
### Vagrant
See [Vagrant's Installation Instructions](http://docs.vagrantup.com/v2/installation/index.html)

### VirtualBox
See [Vagrant's VirtualBox Installation Instructions](http://docs.vagrantup.com/v2/virtualbox/index.html)

### Libarian-Chef
Assuming you have Ruby installed on your system, you should be able to just run:

	gem install librarian-chef

(If you also need Ruby, [go here](https://www.ruby-lang.org/en/downloads/))

### A note about Puppet:
I'm pretty sure you don't need to install Puppet in order for Vagrant to provision boxes with it. If I'm wrong, you can see [Puppet's Installation Instructions](http://docs.puppetlabs.com/guides/installation.html) Follow the instructions for a Standalone Node.

