define encmount::mount(
  $fstype,
  $device,
  $mapper,
  $key,
  $mount=$name,
  $ensure='mounted',
  $options='defaults',
  $temp="/dev/shm/${mapper}"
) {
  include cryptsetup
  $devmapper = "/dev/mapper/${mapper}"

  file { $temp:
    ensure  => 'present',
    backup  => false,
    owner   => root,
    group   => root,
    mode    => '0400',
    notify  => Exec['create key'],
  }

  exec { 'create key':
    command     => "/bin/echo -n '${key}' > ${temp}",
    unless      => "/bin/mount | /bin/grep ${mapper}",
    refreshonly => true,
    notify      => Exec['luksOpen'],
  }

  exec { 'delete key':
    command     => "/bin/echo -n > ${temp}",
    refreshonly => true,
  }

  exec { 'luksOpen':
    command     => "/sbin/cryptsetup --key-file ${temp} luksOpen ${device} ${mapper}",
    onlyif      => "/usr/bin/test ! -b ${devmapper}",
    creates     => $devmapper,
    path        => ['/sbin', '/bin/'],
    refreshonly => true,
    subscribe   => Exec['create key'],
    notify      => [ Exec['delete key'], Mount[$mount] ],
    require     => Class['cryptsetup'],
  }

  mount { $mount:
    ensure  => $ensure,
    atboot  => false,
    device  => $devmapper,
    fstype  => $fstype,
    options => $options,
    require => Exec['luksOpen'],
  }
}
