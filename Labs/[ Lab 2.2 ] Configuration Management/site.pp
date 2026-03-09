  GNU nano 6.2                                        site.pp
# Node classification: apply this block only to db-x
node 'db-a.oe2.org.nz' {

  # Ensure vim is always installed on the db server
  package { 'vim':
    ensure => installed,
  }

}