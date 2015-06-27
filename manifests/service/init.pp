class teamspeak::service::init inherits teamspeak {
  file { 'teamspeak_init':
    ensure  => present,
    path    => "/etc/init.d/${service}",
    content => template($teamspeak::params::init_file),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }
  
  File['teamspeak_init'] -> Service[$service]
}
