Exec {
  path    => ['/usr/sbin', '/usr/bin', '/sbin', '/bin', '/usr/local/bin', '/usr/local/sbin'],
  timeout => 3600,
  user    => 'root',
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

package { 'libpcre3-dev':
  ensure => present,
}

# ------------------------------------------------------------------------------
# DNS Overrides
# ------------------------------------------------------------------------------

file { '/etc/hostname':
  ensure  => file,
  content => 'ubuntu1404.dev',
}

exec { 'Set the hostname':
  command => 'hostname ubuntu1404.dev',
  unless  => "hostname | grep 'ubuntu1404.dev'",
}

# ------------------------------------------------------------------------------
# Bash Scripts
# ------------------------------------------------------------------------------

exec { 'Nicer Bash for Root':
  command => 'curl -sSL http://github.com/brandonwamboldt/dotfiles/archive/master.tar.gz | tar --strip-components=1 -C /root -zx && rm /root/README.md',
  creates => '/root/.functions',
  require => Package['curl'],
}

exec { 'Nicer Bash for Vagrant':
  command => 'curl -sSL http://github.com/brandonwamboldt/dotfiles/archive/master.tar.gz | tar --strip-components=1 -C /home/vagrant -zx && rm /home/vagrant/README.md && chown vagrant:vagrant /home/vagrant -R',
  creates => '/home/vagrant/.functions',
  require => Package['curl'],
}
