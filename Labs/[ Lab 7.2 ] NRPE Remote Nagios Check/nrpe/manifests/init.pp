# modules/nrpe/manifests/init.pp
# Entry point for the nrpe module.
# Apply to monitored agent nodes only -- never to mgmt-a.
class nrpe {

  contain nrpe::install
  contain nrpe::config
  contain nrpe::service

  # install -> config -> service (ordering)
  # config ~> service (config change triggers service restart)
  Class['nrpe::install']
    -> Class['nrpe::config']
    ~> Class['nrpe::service']

}
