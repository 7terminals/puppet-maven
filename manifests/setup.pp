define maven::setup (
  $source        = undef,
  $deploymentdir = undef,
  $user          = undef,
  $pathfile      = '/etc/bashrc',
  $cachedir      = "/var/run/puppet/working-maven-${name}") {
  # working directory to untar maven
  file { $cachedir:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '644',
  }

  # resource defaults for Exec
  Exec {
    path => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'], }

  file { "${cachedir}/${source}":
    source  => "puppet:///modules/${caller_module_name}/${source}",
    require => File[$cachedir],
  }

  exec { "extract_maven-${name}":
    cwd     => $cachedir,
    command => "mkdir extracted; tar -C extracted -xzf ${source} && touch .maven_extracted",
    creates => "${cachedir}/.maven_extracted",
    require => File["${cachedir}/${source}"],
  }

  exec { "create_target_maven-${name}":
    cwd     => '/',
    command => "mkdir -p ${deploymentdir}",
    creates => $deploymentdir,
    require => Exec["extract_maven-${name}"],
  }

  exec { "move_maven-${name}":
    cwd     => $cachedir,
    command => "cp -r extracted/apache-maven*/* ${deploymentdir} && chown -R ${user}:${user} ${deploymentdir}",
    creates => "${deploymentdir}/bin/mvn",
    require => Exec["create_target_maven-${name}"],
  }

  exec { "update_path-${name}":
    cwd     => '/',
    command => "echo 'export PATH=\$PATH:${deploymentdir}/bin' >> ${pathfile}",
    unless  => "grep 'export PATH=\$PATH:${deploymentdir}/bin' ${pathfile}",
    require => Exec["move_maven-${name}"],
  }
}
