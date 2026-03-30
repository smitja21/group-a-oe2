# modules/nagios/manifests/config.pp
# Manages Nagios configuration files and defines monitored hosts.
# Ordering is handled by init.pp -- no cross-class require needed here.
class nagios::config {
  # --- Resource 1: Main Nagios configuration file ---
  # Source is the default nagios.cfg copied into the module's files/ directory.
  # Mirrored path: files/etc/nagios4/nagios.cfg -> /etc/nagios4/nagios.cfg
  file { '/etc/nagios4/nagios.cfg':
    ensure => file,
    owner => 'root',
    group => 'root',
    mode => '0644',
    source => 'puppet:///modules/nagios/etc/nagios4/nagios.cfg',
    require => Package['nagios4'],
  }

  # --- Resource 2: Web interface authentication file ---
  # Created with htpasswd and placed in the module's files/ directory.
  # Contains bcrypt-hashed passwords for the nagiosadmin user.
  file { '/etc/nagios4/htpasswd.users':
    ensure => file,
    owner => 'www-data',
    group => 'www-data',
    mode => '0640',
    source => 'puppet:///modules/nagios/etc/nagios4/htpasswd.users',
    require => Package['nagios4'],
  }

  # --- Resource 3: Ensure nagios user is in puppet group ---
  # This allows nagios to read config files written by Puppet
  user { 'nagios':
    ensure => present,
    groups => 'puppet',
    membership => 'minimum',
    require => Package['nagios4'],
    notify => Service['nagios4'],
  }

  # --- Resource 4: conf.d directory ---
  # Nagios loads all .cfg files from this directory at startup.
  # Puppet writes nagios_host and nagios_service resources into this directory.
  # Group must be 'puppet' so the Puppet agent can write resource files here.
  file { '/etc/nagios4/conf.d':
    ensure => directory,
    owner => 'nagios',
    group => 'nagios',
    mode => '0775',
  }


  # Set Apache ServerName to the group domain.
  # certbot --apache reads this to know which domain to certify.
  # Replace group-x with your group letter.
  file_line { 'apache_servername':
   path => '/etc/apache2/apache2.conf',
   line => 'ServerName group-a.op-bit.nz',
   match => '^ServerName',
  }

#6.1
# --- Host definitions using the defined type ---
  nagios::monitored_host { 'db-a.oe2.org.nz': host_alias => 'db-a' }
  nagios::monitored_host { 'app-a.oe2.org.nz': host_alias => 'app-a' }
  nagios::monitored_host { 'backup-a.oe2.org.nz': host_alias => 'backup-a' }
  nagios::monitored_host { 'mgmt-a.oe2.org.nz': host_alias => 'mgmt-a' }

# --- Host Groups ---
# Group all hosts that run SSH (db, app, backup, and mgmt)
# members must exactly match the nagios_host resource titles
  nagios_hostgroup { 'my-ssh-servers':
    target => '/etc/nagios4/conf.d/ppt_hostgroups.cfg',
    alias => 'All SSH Servers',
    members => 'db-a.oe2.org.nz,app-a.oe2.org.nz,backup-a.oe2.org.nz,mgmt-a.oe2.org.nz',
  }

  # Group containing only the database server
  nagios_hostgroup { 'my-db-servers':
     target => '/etc/nagios4/conf.d/ppt_hostgroups.cfg',
    alias => 'Database Servers',
    members => 'db-a.oe2.org.nz',
  }

  # Group containing the management server for mgmt-specific checks
  nagios_hostgroup { 'my-mgmt-servers':
    target => '/etc/nagios4/conf.d/ppt_hostgroups.cfg',
    alias => 'Management Servers',
    members => 'mgmt-a.oe2.org.nz',

  }

# --- Service: SSH check on all SSH servers ---
# Applies to every member of my-ssh-servers via hostgroup_name.
# When a new host is added to the group, this check follows automatically.
  nagios_service { 'ssh-check':
    service_description => 'SSH',
    hostgroup_name => 'my-ssh-servers',
    target => '/etc/nagios4/conf.d/ppt_services.cfg',
    check_command => 'check_ssh',
    max_check_attempts => 3,
    check_interval => 5,
    retry_interval => 1,
    check_period => '24x7',
    notification_interval => 30,
    notification_period => '24x7',
    notification_options => 'w,u,c,r',
    contact_groups => 'admins',
  }

  # --- Service: MariaDB check on the database server ---
  # Uses check_mysql with credentials stored in resource.cfg ($USER10$/$USER11$)
  # The ! delimiter passes each argument to the command template
  nagios_service { 'mariadb-check':
    service_description => 'MariaDB',
    hostgroup_name => 'my-db-servers',
    target => '/etc/nagios4/conf.d/ppt_services.cfg',
    check_command => 'check_mysql_cmdlinecred!nagios!NagiosMonitor1',
    max_check_attempts => 3,
    check_interval => 5,
    retry_interval => 1,
    check_period => '24x7',
    notification_interval => 30,
    notification_period => '24x7',
    notification_options => 'w,u,c,r',
    contact_groups => 'admins',
  }

  # --- Service: HTTPS check on the management server ---
  # Checks that the Nagios web interface is reachable and returns HTTP 200.
  # -S enables SSL (HTTPS), --sni sends the correct hostname for TLS.
  nagios_service { 'https-nagios':
    service_description => 'HTTPS Nagios Interface',
    hostgroup_name => 'my-mgmt-servers',
    target => '/etc/nagios4/conf.d/ppt_services.cfg',
    check_command => 'check_http! -S 1.2+ --sni -u /nagios4/ -e "HTTP/1.1 401"',
    max_check_attempts => 3,
    check_interval => 5,
    retry_interval => 1,
    check_period => '24x7',
    notification_interval => 30,
    notification_period => '24x7',
    notification_options => 'w,u,c,r',
    contact_groups => 'admins',
  }

}
