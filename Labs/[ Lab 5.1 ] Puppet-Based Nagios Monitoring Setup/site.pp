# site.pp --- refactored with common class

node default {
  # Applied to any node not matched by a specific node block below
  include common
}

node 'db-a.oe2.org.nz' {
  include common
  include mariadb   

  # Ensure vim is always installed on the db server
  package { 'vim':
    ensure => installed,
  }

}

node 'app-a.oe2.org.nz' {
  include common
}

node 'backup-a.oe2.org.nz' {
  include common
}

# mgmt-x should also be a Puppet agent
node 'mgmt-a.oe2.org.nz' {
  include common
  include nagios #mgmt-a ONLY
}
