$ar_databases = ['activerecord_unittest', 'activerecord_unittest2']
$as_vagrant   = 'sudo -u vagrant -H bash -l -c'
$home         = '/home/vagrant'

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# --- Preinstall Stage ---------------------------------------------------------

stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
  exec { 'apt-get -y update':
    unless => "test -e ${home}/.rvm"
  }
}
class { 'apt_get_update':
  stage => preinstall
}
 
# ExecJS runtime.
class { 'nodejs':
  version => 'latest',
}

# --- PhantomJS ----------------------------------------------------------------

# this is required by phantomjs
# https://github.com/ariya/phantomjs/issues/10904
package { "libfontconfig1":
  ensure => installed
}

# Setup phantomjs via netinstall
netinstall { "phantomjs":
  url => "https://phantomjs.googlecode.com/files/phantomjs-1.9.2-linux-x86_64.tar.bz2",
  extracted_dir => "phantomjs-1.9.2-linux-x86_64",
  destination_dir => "/tmp",
  postextract_command => "sudo cp /tmp/phantomjs-1.9.2-linux-x86_64/bin/phantomjs /usr/local/bin/"
}

# PhantomJS environment variable
class phantom_env_var {
    file { '/etc/environment':
        content => inline_template('PHANTOMJS_BIN=/usr/local/bin/phantomjs')
    }
}

# --- Packages -----------------------------------------------------------------

package { 'build-essential':
  ensure => installed
}

package { 'git-core':
  ensure => installed
}

# Nokogiri dependencies.
package { ['libyaml-dev', 'libxml2', 'libxml2-dev', 'libxslt1-dev']:
  ensure => installed
}

# Yeoman, Grunt and Bower
package { 'yo':
  ensure => present,
  provider => 'npm'
}

package { 'bower':
  ensure => present,
  provider => 'npm'
}

package { 'grunt-cli':
  ensure => present,
  provider => 'npm'
}

package { 'grunt-contrib-compass':
  ensure => present,
  provider => 'npm',
  require => Package['grunt-cli']
}

package { 'protractor': 
  ensure => present,
  provider => 'npm'
}
# --- Ruby ---------------------------------------------------------------------

exec { 'install_rvm':
  command => "${as_vagrant} 'curl -L https://get.rvm.io | bash -s stable'",
  creates => "${home}/.rvm",
  require => Package['curl']
}

exec { 'install_ruby':
  command => "${as_vagrant} '${home}/.rvm/bin/rvm install 2.0.0 --autolibs=enabled'",
  creates => "${home}/.rvm/bin/ruby",
  timeout => 600,
  require => [ Package['libyaml-dev'], Exec['install_rvm'] ]
}

exec { 'set_default_ruby': 
  command => "${as_vagrant} '${home}/.rvm/bin/rvm --fuzzy alias create default 2.0.0 && ${home}/.rvm/bin/rvm use default'",
  require => Exec['install_ruby']
}

exec { 'install_bundler':
  command => "${as_vagrant} 'gem install bundler --no-rdoc --no-ri'",
  creates => "${home}/.rvm/bin/bundle",
  require => Exec['set_default_ruby']
}

exec { 'install_compass':
  command => "${as_vagrant} 'gem install compass'",
  require => Exec['install_bundler']
}

# uninstall sass
exec { 'uninstall_sass':
  command => "${as_vagrant} 'gem uninstall -x -I sass'",
  require => Exec['install_compass']
}

# reinstall sass
exec { 'install_sass':
  command => "${as_vagrant} 'gem install -v 3.3.0.alpha.149 sass'",
  require => Exec['uninstall_sass']
}
