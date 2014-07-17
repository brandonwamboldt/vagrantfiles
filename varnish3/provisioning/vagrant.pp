Exec {
  path    => ['/usr/sbin', '/usr/bin', '/sbin', '/bin', '/usr/local/bin', '/usr/local/sbin'],
  timeout => 3600,
  user    => 'root',
}

# ------------------------------------------------------------------------------
# Preinstall Stage
# ------------------------------------------------------------------------------

stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
  exec { 'Update Aptitude':
    command => 'apt-get update',
  }
}

class { 'apt_get_update':
  stage => 'preinstall',
}

# ------------------------------------------------------------------------------
# Ensure VirtualBox guest additions are set to start on boot
# ------------------------------------------------------------------------------

service { 'vboxadd':
  ensure => running,
  enable => true,
}

# ------------------------------------------------------------------------------
# Grub Fix
#
# Fixes an issue where Vagrant gets stuck on the grub boot selection screen.
# ------------------------------------------------------------------------------

file { '/etc/default/grub':
  ensure => file,
  source => '/vagrant/provisioning/files/default/grub',
  owner  => 'root',
  group  => 'root',
  notify => Exec['update-grub'],
}

file { '/etc/grub.d/00_header':
  ensure => file,
  source => '/vagrant/provisioning/files/grub.d/00_header',
  owner  => 'root',
  group  => 'root',
  mode   => '0755',
  notify => Exec['update-grub'],
}

exec { 'update-grub':
  refreshonly => true,
}

# ------------------------------------------------------------------------------
# Install Misc. Packages
#
# Install packages required for the app or other parts of the setup.
# ------------------------------------------------------------------------------

package { 'curl':
  ensure => present,
}

package { 'build-essential':
  ensure => present,
}

package { 'libtool':
  ensure => present,
}

package { 'automake':
  ensure => present,
}

package { 'autoconf':
  ensure => present,
}

package { 'libhiredis-dev':
  ensure => present,
}

package { 'git':
  ensure => present,
}

package { 'vim':
  ensure => present,
}

package { 'wget':
  ensure => present,
}

package { 'unzip':
  ensure => present,
}

# ------------------------------------------------------------------------------
# Compile Varnish from source
# ------------------------------------------------------------------------------

package { 'python-docutils':
  ensure => present,
}

package { 'libncurses5-dev':
  ensure => present,
}

package { 'pkg-config':
  ensure => present,
}

package { 'libpcre3-dev':
  ensure => present,
}

exec { 'Download Varnish Source':
  command => 'curl -sSL https://repo.varnish-cache.org/source/varnish-3.0.5.tar.gz | tar -C /root -zx',
  creates => '/root/varnish-3.0.5',
  require => Package['curl', 'python-docutils', 'build-essential', 'libncurses5-dev', 'pkg-config', 'libpcre3-dev'],
}

exec { 'Configure Varnish Source':
  cwd     => '/root/varnish-3.0.5',
  command => '/root/varnish-3.0.5/configure --prefix=/usr --enable-debugging-symbols',
  creates => '/root/varnish-3.0.5/config.status',
  require => Exec['Download Varnish Source'],
}

exec { 'Make Varnish Source':
  cwd     => '/root/varnish-3.0.5',
  command => 'make',
  creates => '/root/varnish-3.0.5/bin/varnishd/varnishd',
  require => Exec['Configure Varnish Source'],
}

exec { 'Make Install Varnish Source':
  cwd     => '/root/varnish-3.0.5',
  command => 'make install',
  creates => '/usr/bin/varnishd',
  require => Exec['Make Varnish Source'],
}

file { '/etc/init.d/varnish':
  ensure => file,
  source => '/vagrant/provisioning/files/init.d/varnish',
  mode   => '777',
  owner  => 'root',
  group  => 'root',
}

file { '/etc/default/varnish':
  ensure => file,
  source => '/vagrant/provisioning/files/default/varnish',
  mode   => '6444',
  owner  => 'root',
  group  => 'root',
}

file { '/etc/varnish':
  ensure => link,
  target => '/vagrant/varnish',
}

service { 'varnish':
  ensure     => running,
  enable     => true,
  hasrestart => true,
  restart    => '/usr/sbin/service varnish reload',
  require    => [Exec['Make Install Varnish Source'], File['/etc/default/varnish', '/etc/init.d/varnish', '/etc/varnish']],
}

# ----------------------------------------------------------------------------
# Setup PHP-FPM
# ----------------------------------------------------------------------------

package { 'php5-fpm':
  ensure => present,
}

service { 'php5-fpm':
  ensure  => running,
  require => Package['php5-fpm'],
}

# ----------------------------------------------------------------------------
# Setup nginx
# ----------------------------------------------------------------------------

file { '/var/www/':
  ensure => directory,
  owner  => 'vagrant',
  group  => 'vagrant',
}

file { '/var/www/html':
  ensure => link,
  target => '/vagrant/html',
}

file { '/etc/nginx':
  ensure       => directory,
  source       => '/vagrant/provisioning/files/nginx',
  sourceselect => 'all',
  recurse      => true,
  purge        => true,
  force        => true,
  notify       => Service['nginx'],
}

package { 'nginx':
  ensure  => installed,
  require => File['/etc/nginx'],
}

# Why the start/stop/restart/status overrides? The init.d script is broken and
# can't keep track of the process ID
service { 'nginx':
  ensure     => running,
  enable     => true,
  hasrestart => true,
  start      => "service nginx start",
  stop       => "kill \$(ps -ef | grep nginx | grep master | grep -v grep | awk '{print \$2}')",
  restart    => "kill -HUP \$(ps -ef | grep nginx | grep master | grep -v grep | awk '{print \$2}')",
  status     => 'ps -ef | grep nginx | grep master | grep -v grep',
  require    => Package['nginx'],
}

# ------------------------------------------------------------------------------
# Compile the Varnish Agent 2 extension (used by the Varnish Dashboard)
# ------------------------------------------------------------------------------

package { 'libmicrohttpd-dev':
  ensure => installed,
}

package { 'libcurl4-openssl-dev':
  ensure => installed,
}

exec { 'Git Clone Varnish Agent 2':
  command => 'git clone https://github.com/varnish/vagent2.git /root/vagent2 && cd /root/vagent2 && git checkout 3.0',
  creates => '/root/vagent2',
  require => [Exec['Make Install Varnish Source'], Package['pkg-config', 'libmicrohttpd-dev', 'libcurl4-openssl-dev', 'python-docutils']],
}

exec { 'Compile Varnish Agent 2':
  cwd     => '/root/vagent2',
  command => '/root/vagent2/autogen.sh && /root/vagent2/configure --prefix=/usr && make && make install',
  creates => '/usr/bin/varnish-agent',
  require => Exec['Git Clone Varnish Agent 2'],
}

file { '/etc/default/varnish-agent':
  ensure  => file,
  source  => '/vagrant/provisioning/files/default/varnish-agent',
  owner   => 'root',
  group   => 'root',
}

file { '/etc/init.d/varnish-agent':
  ensure  => file,
  source  => '/vagrant/provisioning/files/init.d/varnish-agent',
  owner   => 'root',
  group   => 'root',
  mode    => '0774',
  require => File['/etc/default/varnish-agent'],
}

service { 'varnish-agent':
  ensure  => running,
  enable  => true,
  require => [
    File['/etc/init.d/varnish-agent'],
    Exec['Compile Varnish Agent 2']
  ],
}

# ------------------------------------------------------------------------------
# Grab the Varnish Agent Dashboard
# ------------------------------------------------------------------------------

file { '/var/www/dashboard':
  ensure => link,
  target => '/vagrant/dashboard',
}

exec { 'Git Clone Varnish Dashboard':
  command => 'git clone https://github.com/ITLinuxCL/Varnish-Agent-Dashboard.git /root/varnish-dashboard && cp -Rf /root/varnish-dashboard/* /vagrant/dashboard',
  creates => '/root/varnish-dashboard',
  require => Package['git'],
}

# ------------------------------------------------------------------------------
# Nicer Bash Prompts
# ------------------------------------------------------------------------------

exec { 'Nicer Bash for Root':
  command => 'curl -sSL http://github.com/brandonwamboldt/dotfiles/archive/master.tar.gz | tar --strip-components=1 -C /root -zx && rm /root/README.md',
  creates => '/root/.functions',
  require => Package['curl'],
}

exec { 'Nicer Bash for Vagrant':
  command => 'curl -sSL http://github.com/brandonwamboldt/dotfiles/archive/master.tar.gz | tar --strip-components=1 -C /home/vagrant -zx && rm /home/vagrant/README.md',
  creates => '/home/vagrant/.functions',
  user    => 'vagrant',
  require => Package['curl'],
}

# ------------------------------------------------------------------------------
# Remove Apache 2
# ------------------------------------------------------------------------------

package { 'apache2.2-common': ensure => absent, }
package { 'apache2.2-bin': ensure => absent, }
