# class osquery::config - manage json config in /etc/osquery
class osquery::config (

  $format = 'pretty'

){
  include '::stdlib'

  if $format != 'pretty' {
    file { $::osquery::config:
    ensure  => present,
    content => to_json($::osquery::settings), # format as JSON
    owner   => $::osquery::config_user,
    group   => $::osquery::config_group,
    require => Package[$::osquery::package_name],
    notify  => Service[$::osquery::service_name],
    }
  }
  else {
    file { $::osquery::config:
    ensure  => present,
    content => to_json_pretty($::osquery::settings), # format as JSON
    owner   => $::osquery::config_user,
    group   => $::osquery::config_group,
    require => Package[$::osquery::package_name],
    notify  => Service[$::osquery::service_name],
    }
  }

  if has_key($::osquery::settings, 'packs') {
    $packs = keys($::osquery::settings['packs'])
    osquery::pack { $packs:
      format => $format,
    }
  }

}
