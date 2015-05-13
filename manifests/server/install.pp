# PRIVATE CLASS: do not call directly
class mongodb::server::install {
  $package_ensure = $mongodb::server::package_ensure
  $package_name   = $mongodb::server::package_name
  $nofile         = $mongodb::server::nofile
  $nproc          = $mongodb::server::nproc

  case $package_ensure {
    true:     {
      $my_package_ensure = 'present'
      $file_ensure     = 'directory'
    }
    false:    {
      $my_package_ensure = 'absent'
      $file_ensure     = 'absent'
    }
    'absent': {
      $my_package_ensure = 'absent'
      $file_ensure     = 'absent'
    }
    'purged': {
      $my_package_ensure = 'purged'
      $file_ensure     = 'absent'
    }
    default:  {
      $my_package_ensure = $package_ensure
      $file_ensure     = 'present'
    }
  }

  package { 'mongodb_server':
    ensure  => $my_package_ensure,
    name    => $package_name,
    tag     => 'mongodb',
  }

  file { '/etc/security/limits.d/90-nproc.conf':
    ensure  => present,
    content => template('mongodb/90-nproc.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    require => Package['mongodb_server'],
  }

  file { '/etc/security/limits.d/91-nofile.conf':
    ensure  => present,
    content => template('mongodb/91-nofile.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    require => Package['mongodb_server']
  }
}
