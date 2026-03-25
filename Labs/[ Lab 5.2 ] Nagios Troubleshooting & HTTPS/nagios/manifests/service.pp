# modules/nagios/manifests/service.pp
# Ensures the Nagios4 daemon is running and enabled at boot.
# The ~> arrow in init.pp handles restart when config files change.
class nagios::service {

  service { 'nagios4':
    ensure  => running,
    enable  => true,
    require => Package['nagios4'],
  }

  # Enforce the certbot renewal timer.
  # certbot renew checks all certificates daily and renews if expiring within 30 days.
  # If this timer stops, certificates silently expire and HTTPS breaks for all users.
  service { 'certbot.timer':
    ensure => running,
    enable => true,
  }

}
