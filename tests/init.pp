
maven::setup { 'example.com-maven':
  ensure        => 'present',
  source        => 'apache-maven-3.0.5-bin.tar.gz',
  deploymentdir => '/home/example.com/apps/maven',
  user          => 'example.com',
  pathfile      => '/home/example.com/.bashrc',
}
