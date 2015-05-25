class teamspeak::service::init (
  $install_location
) {
  file { 'teamspeak_init':
    ensure  => present,
    path    => '/etc/init.d/teamspeak',
    content => template($teamspeak::params::init_file),
    owner   => 'root',
    group   => 'root',
    mode    => 755,
  }
  
  File['teamspeak_init'] -> Service['teamspeak']
}