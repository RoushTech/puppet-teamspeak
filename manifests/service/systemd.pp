class teamspeak::service::systemd inherits teamspeak {
  file { 'teamspeak_systemd':
    ensure  => present,
    path    => "/etc/systemd/system/${service}.service",
    content => template($teamspeak::params::systemd_file),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
  
  # https://tickets.puppetlabs.com/browse/PUP-3483
  exec { 'teamspeak_systemd_reload':
    refreshonly => true,
    command     => 'systemctl daemon-reload',
    onlyif      => 'test -e /bin/systemctl',
    path        => [
      '/bin',
      '/usr/bin'
    ],
    subscribe   => File['teamspeak_systemd'],
  }
  
  File['teamspeak_systemd'] -> Service[$service]
}
