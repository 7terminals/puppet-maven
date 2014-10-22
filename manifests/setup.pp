define maven::setup (
  $source        = undef,
  $deploymentdir = undef,
  $user          = undef,
  $pathfile      = '/etc/bashrc',
  $cachedir      = "/var/lib/puppet/working-maven-${name}",
  $ensure        = 'present') {
  # We support only Debian and RedHat
  case $::osfamily {
    Debian  : { $supported = true }
    RedHat  : { $supported = true }
    default : { fail("The ${module_name} module is not supported on ${::osfamily} based systems") }
  }

  # Validate parameters

  if ($source == undef) {
    fail('source parameter must be set')
  }

  if !('.tar.gz' in $source) {
    fail('source must be a .tar.gz archive of Apache Maven')
  }

  if ($deploymentdir == undef) {
    fail('deploymentdir parameter must be set')
  }

  if ($user == undef) {
    fail('user parameter must be set')
  }

  if !($ensure in ['absent', 'present']) {
    fail('ensure parameter must be either absent or present')
  }

  if ($caller_module_name == undef) {
    $mod_name = $module_name
  } else {
    $mod_name = $caller_module_name
  }

  if ($ensure == 'present') {
    # working directory to untar maven
    file { $cachedir:
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '644',
    }

    # resource defaults for Exec
    Exec {
      path => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
    }

    file { "${cachedir}/${source}":
      source  => "puppet:///modules/${mod_name}/${source}",
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

    exec { "update_maven_home-${name}":
      cwd     => '/',
      command => "echo 'export MAVEN_HOME=${deploymentdir}' >> ${pathfile}",
      unless  => "grep 'export MAVEN_HOME=${deploymentdir}' ${pathfile}",
      require => Exec["move_maven-${name}"],
    }

    exec { "update_path-${name}":
      cwd     => '/',
      command => "echo 'export PATH=\${MAVEN_HOME}/bin:\$PATH' >> ${pathfile}",
      unless  => "grep 'export PATH=\${MAVEN_HOME}/bin:\$PATH' ${pathfile}",
      require => Exec["update_maven_home-${name}"],
    }
  } else {
    file { $deploymentdir:
      ensure  => 'absent',
      recurse => true,
      force   => true,
    }

    file { $cachedir:
      ensure  => 'absent',
      recurse => true,
      force   => true,
    }
  }
}
