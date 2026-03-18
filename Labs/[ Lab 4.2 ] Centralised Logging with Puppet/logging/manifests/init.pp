# modules/logging/manifests/init.pp
# Manages centralised rsyslog configuration.
# mgmt-a acts as the log server; all other nodes are clients.

class logging {

	contain logging::config
	contain logging::service

	# config must be applied before the service starts/restarts
	Class['logging::config'] -> Class['logging::service']

	# any config change triggers a service restart
	Class['logging::config'] ~> Class['logging::service']

}
