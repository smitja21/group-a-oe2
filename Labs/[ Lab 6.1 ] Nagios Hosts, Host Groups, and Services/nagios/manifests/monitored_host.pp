# modules/nagios/manifests/monitored_host.pp
# A defined type that creates a standard nagios_host resource.
# Usage: nagios::monitored_host { 'hostname.oe2.org.nz': alias => 'short' }
define nagios::monitored_host (
  String $host_alias = $title,
  String $check_command = 'check-host-alive',
  Integer $max_check_attempts = 3,
  Integer $notification_interval = 30,
  String $notification_options = 'd,u,r',
) {

  nagios_host { $title:
    target => '/etc/nagios4/conf.d/ppt_hosts.cfg',
    alias => $host_alias,
    check_period => '24x7',
    max_check_attempts => $max_check_attempts,
    check_command => $check_command,
    notification_interval => $notification_interval,
    notification_period => '24x7',
    notification_options => $notification_options,
  }
}
