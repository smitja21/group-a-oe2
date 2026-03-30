#modules/mariadb/manifests/init.pp
# Entry point for the MariaDB module
# Uses contain + ordering arrows to enforce: install -> config -> service

class mariadb {

        contain mariadb::install
        contain mariadb::config
        contain mariadb::service

        # Enforce application order across sub-classes
	Class['mariadb::install'] -> Class['mariadb::config'] -> Class['mariadb::service']
	
	#Notification: when config changes, trigger a service refresh
	Class['mariadb::config']
	~> Class['mariadb::service']
}
