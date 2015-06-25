# Teamspeak Module

Manages a single teamspeak instance install. Installs by default on /opt/teamspeak.

## Quick Start

### Installing defaults

```puppet
include teamspeak
```

### Install specific version

```puppet
class { 'teamspeak':
  version => '3.0.11.3',
}
```

### Install specific version, deploy license file

```puppet
class { 'teamspeak':
  version      => '3.0.11.3',
  license_file => 'puppet:///modules/roles/teamspeak/licensekey.dat',
}
```

### Install with all parameters set

```puppet
class { 'teamspeak':
  version      => '3.0.11.3',
  license_file => 'puppet:///modules/roles/teamspeak/licensekey.dat',
  arch         => 'x86',  # x86 or amd64
  user         => 'teamspeak',
  group        => 'teamspeak',
  init         => 'init', # or 'systemd'
  home         => '/opt/teamspeak',
  service      => 'teamspeak'
}
```

## Supported platforms

Currently Debian and RedHat family should work.

x86 and AMD64 only.

## Possible future features

* Hiera support
* Automatic detection of latest version
* Multiple mirrors

## License

See LICENSE file for details.

## Authors

William Roush <william.roush@roushtech.net>