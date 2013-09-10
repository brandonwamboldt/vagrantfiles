# We're using Ubuntu 12.04, but we want to use the repos from 13.04

file { '/etc/apt/sources.list':
  ensure => 'present',
  target => '/vagrant/vagrant/puppet/apt/sources.list',
  notify => [Exec['Import Aptitude GPG keys'], Exec['Update Aptitude sources to use Raring Ringtail sources']],
}

exec { 'Import Aptitude GPG keys':
  command     => '/usr/bin/apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 3B4FE6ACC0B21F32',
  require     => File['/etc/apt/sources.list'],
  refreshonly => true,
}

exec { 'Update Aptitude sources to use Raring Ringtail sources':
  command     => '/usr/bin/apt-get update',
  require     => Exec['Import Aptitude GPG keys'],
  refreshonly => true,
}

# Misc. dependencies

package { 'curl':
  ensure  => 'present',
  require => Exec['Update Aptitude sources to use Raring Ringtail sources'],
}

package { 'wget':
  ensure  => 'present',
  require => Exec['Update Aptitude sources to use Raring Ringtail sources'],
}

package { 'build-essential':
  ensure  => 'present',
  require => Exec['Update Aptitude sources to use Raring Ringtail sources'],
}

package { 'git':
  ensure  => 'present',
  require => Exec['Update Aptitude sources to use Raring Ringtail sources'],
}

package { 'unzip':
  ensure  => 'present',
  require => Exec['Update Aptitude sources to use Raring Ringtail sources'],
}

# Install Node.js

exec { 'Download and Install Node.js':
  command => '/usr/bin/curl -sS http://nodejs.org/dist/v0.10.18/node-v0.10.18-linux-x86.tar.gz > /opt/node.tar.gz && /bin/tar -xvzf /opt/node.tar.gz && /bin/rm /opt/node.tar.gz && /bin/mv node-v0.10.18-linux-x86 /opt/node',
  creates => '/opt/node',
  require => Package['curl'],
}

exec { 'Install Nodemon':
  command => '/opt/node/bin/npm install -g nodemon',
  creates => '/opt/node/bin/nodemon',
  require => Exec['Download and Install Node.js'],
}

exec { 'Install Grunt':
  command => '/opt/node/bin/npm install -g grunt-cli',
  creates => '/opt/node/bin/grunt',
  require => Exec['Download and Install Node.js'],
}

file { '/usr/bin/node':
  ensure => 'link',
  target => '/opt/node/bin/node',
}

file { '/usr/bin/nodemon':
  ensure => 'link',
  target => '/opt/node/bin/nodemon',
}

file { '/usr/bin/npm':
  ensure => 'link',
  target => '/opt/node/bin/npm',
}

file { '/usr/bin/grunt':
  ensure => 'link',
  target => '/opt/node/bin/grunt',
}

# Install Project Dependencies

exec { 'Installing NPM dependencies':
  cwd     => '/var/www/html/express',
  command => '/opt/node/bin/npm install --no-bin-links -d',
  creates => '/var/www/html/express/node_modules',
  require => Exec['Download and Install Node.js'],
}

# Start Project Server

exec { 'Starting Node.js via Nodemon':
  cwd     => '/var/www/html/express',
  command => '/usr/bin/nohup /opt/node/bin/grunt server > /dev/null 2>&1 &',
  require => Exec['Install Grunt'],
}
