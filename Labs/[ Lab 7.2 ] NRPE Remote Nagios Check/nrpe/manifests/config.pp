# modules/nrpe/manifests/config.pp
# Deploys the nrpe.cfg configuration file from an ERB template.
# The template inserts the correct mgmt-a FQDN into allowed_hosts.
class nrpe::config {

  # Deploy the NRPE configuration file from the ERB template.
  # The template has access to all Puppet facts for this node.
  file { '/etc/nagios/nrpe.cfg':
    ensure  => file,
    owner   => 'root',
    group   => 'nagios',
    mode    => '0640', # nagios group can read; others cannot
    content => template('nrpe/nrpe.cfg.erb'),
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

}
