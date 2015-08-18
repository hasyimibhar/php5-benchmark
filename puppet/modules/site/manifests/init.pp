class site(
    $user,
    $php_version,
) {

    user { "$user":
        ensure => present,
        home => "/home/$user"
    }

    include php
    include php::params

    class { 'php::fpm':
        ensure => $php_version
    }

    create_resources('php::fpm::pool', hiera_hash('php_fpm_pool', {}))

    class { ['php::dev', 'php::cli']:
        ensure => installed;
    }

    Package['php5-common']
        -> Package['php5-fpm']
        -> Package['php5-cli']
        -> Package['php5-dev']
        ~> Service['php5-fpm']

    file { '/var/www':
        ensure => directory,
    }

    file { '/var/www/site':
        ensure => directory,
        require => File['/var/www'],
    }

    file { '/var/www/site/index.php':
        ensure => present,
        source => 'puppet:///modules/site/index.php',
        require => File['/var/www/site'],
    }

    class { 'nginx': }

    file { '/etc/nginx/sites-available/site':
        ensure => present,
        source => 'puppet:///modules/site/site-vhost.cfg'
    }

    file { '/etc/nginx/sites-enabled/site':
        ensure => link,
        target => '/etc/nginx/sites-available/site'
    }

    exec { 'reload-nginx':
        command => 'service nginx reload',
        path => '/usr/bin:/bin:/usr/sbin:/usr/local/bin'
    }

    Package['nginx']
        -> File['/etc/nginx/sites-available/site']
        -> File['/etc/nginx/sites-enabled/site']
        ~> Exec['reload-nginx']
}
