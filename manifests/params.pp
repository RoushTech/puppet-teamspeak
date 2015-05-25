class teamspeak::params {
  $init_file    = "teamspeak/init/${::osfamily}.init.erb"
  $systemd_file = "teamspeak/systemd/teamspeak.erb"
  $version      = '3.0.11.3'
  $arch         = $::architecture
  $mirror       = 'http://dl.4players.de/ts/releases/<%=version%>/teamspeak3-server_linux-<%=download_arch%>-<%=version%>.tar.gz'
  
  if !($arch in ['i386', 'amd64']) {
    fail("${arch} is not currently supported!")
  }
  
  if !($::osfamily in ['Debian']) {
    fail("${::osfamily} is not currently supported!")
  }
  
  if $arch == 'i386' {
    $download_arch = 'x86'
  } else {
    $download_arch = $arch
  }
}