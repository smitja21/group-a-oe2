# modules/nagios_slack/manifests/config.pp
# Deploys the Nagios command definitions for Slack notifications.
# These commands are called by Nagios when a contact is notified.
class nagios_slack::config {
# Deploy the Slack command definitions file into Nagios's conf.d directory.
# Nagios loads all .cfg files from conf.d/ automatically.
# This file defines two commands:
# notify-service-by-slack : used for service alerts
# notify-host-by-slack : used for host up/down alerts
  file { '/etc/nagios4/conf.d/slack_commands.cfg':
    ensure => file,
    owner => 'root',
    group => 'nagios',
    mode => '0644',
    content => template('nagios_slack/slack_commands.cfg.erb'),
    require => File['/usr/lib/nagios/plugins/nagios.pl'],
    notify => Service['nagios4'],
  }
}
