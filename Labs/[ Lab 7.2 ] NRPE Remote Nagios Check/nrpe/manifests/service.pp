# modules/nrpe/manifests/service.pp
# Ensures the NRPE daemon is running and enabled at boot.
# The ~> arrow in init.pp causes a restart when config changes.
class nrpe::service {

  service { 'nagios-nrpe-server':
    ensure  => running,
    enable  => true,
    require => Package['nagios-nrpe-server'],
  }

}
