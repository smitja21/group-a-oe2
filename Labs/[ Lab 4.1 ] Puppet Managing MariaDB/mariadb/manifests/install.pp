# modules/mariadb/manifests/install.pp
# Installs the MariaDB server package
#
# DO NOT manage the mysql user or group here
# The mariadb-server apt package creates the mysql system user and group
# automatically during its post-install script. Pre-creating them with
# Puppet causes UID/GID conflects and package install failures

class mariadb::install {
	package { 'mariadb-server':
		ensure => present,
	}
}
