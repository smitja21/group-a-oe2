# modules/nrpe/manifests/install.pp
# Installs the NRPE server daemon and the Nagios monitoring plugins.
# Applied to monitored agent nodes (db-a, app-a, backup-a) only.
# Do NOT apply to mgmt-a.
class nrpe::install {

  # NRPE server daemon -- listens on TCP 5666 for check requests
  package { 'nagios-nrpe-server':
    ensure => present,
  }

  # Monitoring plugins executed locally by NRPE
  # These are the same plugins used by Nagios on mgmt-a
  package { 'monitoring-plugins':
    ensure  => present,
    require => Package['nagios-nrpe-server'],
  }

}
