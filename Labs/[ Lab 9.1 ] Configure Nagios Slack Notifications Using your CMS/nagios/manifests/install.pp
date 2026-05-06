# modules/nagios/manifests/install.pp
# Installs Nagios, its monitoring plugins, and the Apache utilities
# needed to manage the web interface password file.
#comment
class nagios::install {
  # Core Nagios monitoring daemon
  package { 'nagios4':
  ensure => present,
  }

  # Check scripts used by Nagios to test hosts and services
  # (check_ping, check_ssh, check_http, check_tcp, etc.)
  package { 'monitoring-plugins':
    ensure => present,
    require => Package['nagios4'],
  }

  # Provides the htpasswd command used to create the web login password file
  package { 'apache2-utils':
    ensure => present,
  }

  # The CGI module must be enabled in Apache for the Nagios web interface
  # to work. Without this, accessing /nagios4 returns HTTP 500.
  exec { 'enable_apache_cgi':
    command => '/usr/sbin/a2enmod cgi',
    unless => '/usr/sbin/apache2ctl -M 2>/dev/null | grep -q cgi_module',
    notify => Service['apache2'],
    require => Package['nagios4'],
  }

  service { 'apache2':
    ensure => running,
    enable => true,
  }

}
