# Misc. dependencies

package { 'curl':
  ensure  => 'present',
}

package { 'wget':
  ensure  => 'present',
}

package { 'build-essential':
  ensure  => 'present',
}

package { 'git':
  ensure  => 'present',
}

package { 'unzip':
  ensure  => 'present',
}

# Setup Apache

package { 'apache2':
  ensure  => 'present',
}

service { 'apache2':
  ensure  => 'running',
  enable  => 'true',
  require => Package['apache2'],
}

file { '/etc/apache2/ports.conf':
  notify  => Service['apache2'],
  require => Package['apache2'],
  ensure  => 'file',
  source  => '/vagrant/vagrant/puppet/apache/ports.conf',
}

file { '/etc/apache2/sites-available/default':
  notify  => Service['apache2'],
  require => Package['apache2'],
  ensure  => 'file',
  source  => '/vagrant/vagrant/puppet/apache/default_vhost.conf',
}

file { '/etc/apache2/sites-available/default-ssl.conf':
  require => Package['apache2'],
  ensure  => 'absent',
}

file { 'Enable mod_rewrite':
  path    => '/etc/apache2/mods-enabled/rewrite.load',
  notify  => Service['apache2'],
  require => Package['apache2'],
  ensure  => 'link',
  target  => '/etc/apache2/mods-available/rewrite.load',
}

# Setup MySQL

package { 'mysql-server':
  ensure  => 'present',
}

service { 'mysql':
  ensure  => 'running',
  enable  => 'true',
  require => Package['mysql-server'],
}

exec { 'Drop anonymous MySQL users':
  require  => Package['mysql-server'],
  command  => '/bin/echo "DELETE FROM mysql.user WHERE User = \'\'" | /usr/bin/mysql -u root',
  onlyif   => "/usr/bin/mysql -u root -e \"SELECT User FROM mysql.user WHERE User LIKE ''\" | /bin/grep 'User'",
}

# Install PHP and required PHP extensions

package { 'php5':
  ensure  => 'present',
  notify  => Service['apache2'],
}

package { 'php-pear':
  ensure  => 'present',
  notify  => Service['apache2'],
  require => Package['php5'],
}

package { 'php5-cli':
  ensure  => 'present',
  notify  => Service['apache2'],
  require => Package['php5'],
}

package { 'php5-curl':
  ensure  => 'present',
  notify  => Service['apache2'],
  require => Package['php5'],
}

package { 'php5-dev':
  ensure  => 'present',
  notify  => Service['apache2'],
  require => Package['php5'],
}

package { 'php5-intl':
  ensure  => 'present',
  notify  => Service['apache2'],
  require => Package['php5'],
}

package { 'php5-gd':
  ensure  => 'present',
  notify  => Service['apache2'],
  require => Package['php5'],
}

package { 'php5-mcrypt':
  ensure  => 'present',
  notify  => Service['apache2'],
  require => Package['php5'],
}

package { 'php5-memcache':
  ensure  => 'present',
  notify  => Service['apache2'],
  require => Package['php5'],
}

package { 'php5-mysql':
  ensure  => 'present',
  notify  => Service['apache2'],
  require => Package['php5'],
}

# phpMyAdmin

exec { 'Download phpMyAdmin':
  require => [Package['php5'], Package['git']],
  cwd     => '/var/www/html',
  command => '/usr/bin/git clone --depth 1 https://github.com/phpmyadmin/phpmyadmin.git',
  creates => '/var/www/html/phpmyadmin',
}

file { '/var/www/html/phpmyadmin/config.inc.php':
  require => Exec['Download phpMyAdmin'],
  ensure  => 'file',
  source  => '/vagrant/vagrant/puppet/phpmyadmin/config.inc.php',
}

# Install Composer

exec { 'Install PHP Composer':
  require => [Package['php5'], Package['curl']],
  cwd     => '/usr/bin',
  command => '/usr/bin/curl -sS https://getcomposer.org/installer | /usr/bin/php',
  creates => '/usr/bin/composer.phar',
}

file { '/usr/bin/composer':
  ensure => 'link',
  target => '/usr/bin/composer.phar',
}

# Install WordPress

exec { 'Download & Extract WordPress':
  require => Package['unzip'],
  command => '/usr/bin/curl -sS  http://wordpress.org/wordpress-3.6-no-content.zip > /tmp/wordpress.zip && /usr/bin/unzip -oq /tmp/wordpress.zip -d /var/www/html/wordpress/app && /bin/mv -f /var/www/html/wordpress/app/wordpress/* /var/www/html/wordpress/app && /bin/rm -r /var/www/html/wordpress/app/wordpress',
  creates => '/var/www/html/wordpress/app/index.php',
}

exec { 'Download & Extract Twenty Thirteen':
  require => Exec['Download & Extract WordPress'],
  command => '/usr/bin/curl -sS http://wordpress.org/themes/download/twentythirteen.1.0.zip > /var/www/html/wordpress/app/wp-content/themes/twentythirteen.zip && /usr/bin/unzip -oq /var/www/html/wordpress/app/wp-content/themes/twentythirteen.zip -d /var/www/html/wordpress/app/wp-content/themes && /bin/rm /var/www/html/wordpress/app/wp-content/themes/twentythirteen.zip',
  creates => '/var/www/html/wordpress/app/wp-content/themes/twentythirteen',
}

# Install WP-CLI

exec { 'Install WP-CLI':
  command     => '/usr/bin/curl https://raw.github.com/wp-cli/wp-cli.github.com/master/installer.sh | /bin/bash',
  environment => 'INSTALL_DIR=/opt/wp-cli',
  require     => Package['php5'],
  creates     => '/opt/wp-cli',
}

file { '/usr/bin/wp':
  ensure => 'link',
  target => '/opt/wp-cli/bin/wp',
}

# WordPress config

file { '/var/www/html/wordpress/app/wp-config.php':
  ensure => 'file',
  source => '/vagrant/vagrant/puppet/wordpress/wp-config.php',
}

exec { 'Create WordPress Database':
  require  => [Package['mysql-server'], Exec['Install WP-CLI'], File['/var/www/html/wordpress/app/wp-config.php']],
  command  => '/bin/echo "CREATE DATABASE wordpress" | /usr/bin/mysql -u root',
  unless   => "/usr/bin/mysql -e \"SHOW DATABASES LIKE 'wordpress'\" | /bin/grep 'wordpress'",
  notify   => Exec['Install WordPress'],
}

exec { 'Install WordPress':
  command     => '/usr/bin/wp core install --url=http://localhost:5000 --title=WordPress --admin_name=admin --admin_password=admin --admin_email=admin@example.com --path=/var/www/html/wordpress/app',
  refreshonly => true,
  require     => Exec['Create WordPress Database'],
}
