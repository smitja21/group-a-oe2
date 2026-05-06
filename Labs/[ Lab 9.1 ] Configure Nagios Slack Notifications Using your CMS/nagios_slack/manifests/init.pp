# modules/nagios_slack/manifests/init.pp
# Slack notification plugin for Nagios.
# Apply to mgmt-x only -- the Nagios server.
class nagios_slack {
  contain nagios_slack::install
  contain nagios_slack::config
  # install must complete before config (plugin must exist
  # before the command definitions reference it)
  Class['nagios_slack::install'] -> Class['nagios_slack::config']
}
