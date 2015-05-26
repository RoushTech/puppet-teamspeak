# == Class: teamspeak
#
# Manages Teamspeak install.
#
# === Parameters
#
# [*version*]
#   Version of Teamspeak server to download.
#
# [*arch*]
#    Defines the architecture of the binary of Teamspeak that we're
#    downloading, defaults to your systems arch. Manually setting this
#    to "i386" will not automatically resolve i386 => x86, this is the arch
#    used in the download URI.
#
# [*mirror*]
#    Defines the architecture mirror URL to download from, defaults to
#    'http://dl.4players.de/ts/releases/<%=version%>/teamspeak3-server_linux-<%=download_arch%>-<%=version%>.tar.gz'.
#
# [*license_file*]
#    Source link to license file, optional. 
#
# === Examples
#
#  include teamspeak
#
#  class { teamspeak:
#      version => '3.0.11.3',
#      arch    => 'x86',
#  }
#
#  class { teamspeak:
#      version      => '3.0.11.3',
#      license_file => 'puppet:///modules/roles/teamspeak/licensekey.dat'
#  }
#
# === Authors
#
# William Roush <william.roush@roushtech.net>
#
# === Copyright
#
# Copyright 2015 William Roush
#

class teamspeak (
  $version         = $teamspeak::params::version,
  $arch            = $teamspeak::params::download_arch,
  $mirror          = $teamspeak::params::mirror,
  $license_file    = undef,
) inherits ::teamspeak::params  {

  package { 'wget':
    ensure => present,
  }
  
  group { 'teamspeak':
    ensure => present,
  }
  
  user { 'teamspeak':
    ensure     => present,
    managehome => true,
    home       => '/opt/teamspeak',
    groups     => 'teamspeak',
    require    => Group['teamspeak'],
  }
  
  $teamspeak_dirs = [
    '/opt/teamspeak',
    '/opt/teamspeak/downloads',
  ]
  
  file { $teamspeak_dirs:
    ensure  => directory,
    owner   => 'teamspeak',
    group   => 'teamspeak',
    mode    => '750',
    require => [
      User['teamspeak'],
      Group['teamspeak'],
    ],
  }
  
  $parsed_mirror = inline_template($mirror)
  exec { 'download_teamspeak':
    command => "wget -q ${parsed_mirror}",
    path    => '/usr/bin',
    cwd     => '/opt/teamspeak/downloads',
    user    => 'teamspeak',
    group   => 'teamspeak',
    creates => "/opt/teamspeak/downloads/teamspeak3-server_linux-${arch}-${version}.tar.gz",
    require => [
      File['/opt/teamspeak/downloads'],
      User['teamspeak'],
      Package['wget'],
    ],
  }
  
  exec { 'unpack_teamspeak':
    command     => "tar -xzf /opt/teamspeak/downloads/teamspeak3-server_linux-${arch}-${version}.tar.gz -C /opt/teamspeak/downloads",
    path        => '/bin',
    user        => 'teamspeak',
    refreshonly => true,
    subscribe   => Exec['download_teamspeak'],
  }
  
  exec { 'move_teamspeak':
    command     => "mv teamspeak3-server_linux-${arch}/* /opt/teamspeak",
    cwd         => '/opt/teamspeak/downloads',
    path        => '/bin',
    user        => 'teamspeak',
    refreshonly => true,
    subscribe   => Exec['unpack_teamspeak'],
  }
  
  file { 'delete_temp_teamspeak':
    ensure    => absent,
    path      => "/opt/teamspeak/downloads/teamspeak3-server_linux-${arch}",
    subscribe => Exec['move_teamspeak'],
    recurse   => true,
    purge     => true,
    force     => true,
  }
  
  if $license_file != undef {
    file { 'teamspeak_license':
      ensure => present,
      path   => '/opt/teamspeak/licensekey.dat',
      source => $license_file,
      owner  => 'teamspeak',
      group  => 'teamspeak',
      mode   => 660,
    }
  }
  
  service { 'teamspeak':
    ensure   => running,
    enable   => true,
  }
  
  include teamspeak::service::init
  include teamspeak::service::systemd
}