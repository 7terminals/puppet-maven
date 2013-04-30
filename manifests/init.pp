# Class: maven
#
# The Apache Maven module allows Puppet to install maven and update the bashrc file to include maven in the path.
#
# Parameters: ensure, source, deploymentdir, user, pathfile
#
# Sample Usage:
#    maven::setup { "example.com-maven":
#      ensure        => 'present',
#      source        => 'apache-maven-3.0.5-bin.tar.gz',
#      deploymentdir => '/home/example.com/apps/apache-maven',
#      user          => 'example.com',
#      pathfile      => '/home/example.com/.bashrc'
#    }
class maven {

}
