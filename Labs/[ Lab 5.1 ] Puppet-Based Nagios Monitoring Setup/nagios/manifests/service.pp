# modules/nagios/manifests/service.pp
# Ensures the Nagios4 daemon is running and enabled at boot.
# The ~> arrow in init.pp handles restart when config files change.
class nagios::service {
    service { 'nagios4':
    ensure => running,
    enable => true,
    require => Package['nagios4'],
  }
}
