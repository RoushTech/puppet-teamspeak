class teamspeak::params {
    $init_file    = "teamspeak/init/${::osfamily}.init.erb"
    $systemd_file = 'teamspeak/systemd/teamspeak.erb'
    $version      = '3.0.13.6'
    $arch         = $::architecture
    $mirror       = 'http://dl.4players.de/ts/releases/<%=@version%>/teamspeak3-server_linux_<%=@download_arch%>-<%=@version%>.tar.bz2'

    case $::osfamily {
        'Debian': {
            if $arch == 'i386' {
                $download_arch = 'x86'
            } else {
                $download_arch = $arch
            }
        }
        'RedHat': {
            if $arch == 'x86_64' {
                $download_arch = 'amd64'
            } else {
                $download_arch = 'x86'
            }
        }
        'Suse': {
            if $arch == 'x86_64' {
                $download_arch = 'amd64'
            } else {
                $download_arch = 'x86'
            }
        }
        default: {
        }
    }

if ($::osfamily == 'Debian') and ($::operatingsystemmajrelease >= '8') {
    $init = 'systemd'
}
if ($::osfamily == 'Debian') and ($::operatingsystemmajrelease < '8') {
    $init = 'init'
}
if ($::osfamily == 'RedHat') and ($::operatingsystemmajrelease >= '7') {
    $init = 'systemd'
}
if ($::osfamily == 'RedHat') and ($::operatingsystemmajrelease < '7') {
    $init = 'init'
}
if ($::osfamily == 'Suse') and ($::operatingsystemmajrelease >= '42') {
    $init = 'systemd'
}
if ($::osfamily == 'Suse') and ($::operatingsystemmajrelease < '42') {
    $init = 'init'
}

case 

    if !($arch in ['i386', 'amd64', 'x86_64']) {
        fail("${arch} is not currently supported!")
    }

    if !($::osfamily in ['Debian', 'RedHat', 'Suse']) {
        fail("${::osfamily} is not currently supported!")
    }

}
