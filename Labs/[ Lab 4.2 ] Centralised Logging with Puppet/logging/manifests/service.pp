# modules/logging/manifests/service.pp
# Ensures the rsyslog service is running and enabled at boot.
# The ~> arrow in init.pp handles restart-on-config-change.

class logging::service {

	service { 'rsyslog':
	  ensure => running, 
	  enable => true,
        }

} 
