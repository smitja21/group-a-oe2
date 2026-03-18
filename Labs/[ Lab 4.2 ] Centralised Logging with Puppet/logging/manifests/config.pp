# modules/logging/manifests/config.pp
# Deploys the rsyslog drop-in configuration file.
# Uses an ERB template to configure the node as either a server or client
# based on whether it is mgmt-x (the Puppet/log server).
class logging::config (
  String $log_server = 'mgmt-a',
) {


  # Ensure rsyslog is installed
  package { 'rsyslog':
    ensure => present,
  }  


  # Determine this node's role from its hostname fact
  $is_server = ($facts['networking']['hostname'] == $log_server)

  # On the server only: ensure the remote log directory exists
  # Clients do not need this directory
  if $is_server {
    file { '/var/log/remote':
      ensure => directory,
      owner  => 'syslog',
      group  => 'adm',
      mode   => '0750',
    }
  }

  # Deploy the rsyslog drop-in config via ERB template
  # This file is placed in rsyslog.d/ so it does not overwrite
  # the main rsyslog.conf (which contains Ubuntu's own defaults)
  file { '/etc/rsyslog.d/90-puppet-managed.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('logging/rsyslog.conf.erb'),
  }

  # On the server only: open port 514 in the firewall
  # The 'unless' guard makes this idempotent
  if $is_server {
    exec { 'allow_syslog_tcp':
      command => '/usr/sbin/ufw allow proto tcp from any to any port 514',
      unless  => '/usr/sbin/ufw status | grep -q "514/tcp"',
      path    => ['/usr/sbin', '/usr/bin', '/bin'],
    }
  }

}
