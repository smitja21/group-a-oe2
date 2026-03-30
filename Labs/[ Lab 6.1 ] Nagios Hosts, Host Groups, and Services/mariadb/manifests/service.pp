# modules/mariadb/manifests/service.pp
# Ensures the MariaDB service is running and enabled at boot.
# The mariadb-server package installs a systemd unit named 'mariadb',
# but also provides a 'mysql' alias. Either name works; 'mariadb' is canonical

class mariadb::service {

	service { 'mariadb':
		ensure => running,
		enable => true,
	}
}
