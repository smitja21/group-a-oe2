# modules/mariadb/manifests/config.pp
# Deploys the MariaDB server configuration file.
# Ordering is handled by init.pp -- no cross-class require needed here.

class mariadb::config {

	file { '/etc/mysql/mariadb.conf.d/50-server.cnf':
		ensure => file,
		owner => 'root',
		group => 'root',
		mode => '0644',
		source => 'puppet:///modules/mariadb/etc/mysql/mariadb.conf.d/50-server.cnf',
		require => Package['mariadb-server'],
	}
}
