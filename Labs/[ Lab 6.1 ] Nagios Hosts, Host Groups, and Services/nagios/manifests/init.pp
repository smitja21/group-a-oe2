# modules/nagios/manifests/init.pp
# Entry point for the nagios module.
# Nagios runs on mgmt-x ONLY -- never include this in the common class.
#comment
class nagios {
  contain nagios::install
  contain nagios::config
  contain nagios::service
  
  # Enforce application order
  Class['nagios::install']
  -> Class['nagios::config']
  ~> Class['nagios::service']
}
