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
# === Variables
#
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
  
  $parsed_mirror = inline_template($mirror)
  $install_location = "/opt/teamspeak/teamspeak3-server_linux-${arch}"
  exec { 'download_teamspeak':
    command => "wget -q ${parsed_mirror}",
    path    => '/usr/bin',
    cwd     => '/opt/teamspeak',
    user    => 'teamspeak',
    creates => "/opt/teamspeak/teamspeak3-server_linux-${arch}-${version}.tar.gz",
    require => [
      User['teamspeak'],
      Package['wget'],
    ],
  }
  
  exec { 'unpack_teamspeak':
    command     => "tar -xzf /opt/teamspeak/teamspeak3-server_linux-${arch}-${version}.tar.gz -C /opt/teamspeak",
    path        => '/bin',
    user        => 'teamspeak',
    refreshonly => true,
    subscribe   => Exec['download_teamspeak'],
  }
  
  service { 'teamspeak':
    ensure   => running,
    enable   => true,
  }
  
  class { 'teamspeak::service::init':
    install_location => $install_location 
  }
  
  class { 'teamspeak::service::systemd':
    install_location => $install_location 
  }
}