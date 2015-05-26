# Teamspeak Module

Manages a single teamspeak instance install. Installs on /opt/teamspeak.

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

## Supported platforms

Currently only Debian is tested, Redhat should work fine once you add it to the supported platforms, pull requests would be appreciated by people on different platforms.

x86 and AMD64 only.

## Possible future features

* Hiera support
* Automatic detection of latest version
* Multiple mirrors

## License

See LICENSE file for details.

## Authors

William Roush <william.roush@roushtech.net>