# modules/nagios_slack/manifests/install.pp
# Installs the Perl dependencies and deploys the nagios.pl Slack plugin.
# Applied to mgmt-x only (where Nagios runs).
class nagios_slack::install {

  # Required Perl modules for the Slack notification plugin.
  # libwww-perl: provides LWP (HTTP client library)
  # libcrypt-ssleay-perl: SSL/TLS support for LWP
  # liblwp-protocol-https-perl: HTTPS support for LWP
  package { ['libwww-perl', 'libcrypt-ssleay-perl', 'liblwp-protocol-https-perl']:
    ensure => present,
  }

# Deploy the pre-configured Slack notification plugin.
# The file in modules/nagios_slack/files/nagios.pl already has
# $opt_domain and $opt_token set to the correct values.
# Mode 0755: executable by all users (nagios daemon runs as nagios user)
  file { '/usr/lib/nagios/plugins/nagios.pl':
    ensure => file,
    owner => 'root',
    group => 'root',
    mode => '0755',
    source => 'puppet:///modules/nagios_slack/nagios.pl',
    require => Package['libwww-perl'],
  }
}
