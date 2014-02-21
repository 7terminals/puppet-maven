maven
====


Overview
--------

The Apache Maven module installs the maven build tool.


Module Description
-------------------

The Apache Maven module allows Puppet to install maven and update the bashrc file to include maven in the path. 

Setup
-----

**What maven affects:**

* installation directory for maven
* bashrc file of the user or /etc/bashrc if parameter pathfile is not set 
	
### Beginning with Apache Maven

To setup Apache Maven on a server

    maven::setup { "example.com-maven":
      ensure        => 'present',
      source        => 'apache-maven-3.0.5-bin.tar.gz',
      deploymentdir => '/home/example.com/apps/apache-maven',
      user          => 'example.com',
      pathfile      => '/home/example.com/.bashrc'
    }

Usage
------

The `maven::setup` resource definition has several parameters to assist installation of maven.

**Parameters within `maven`**

####`ensure`

This parameter specifies whether maven should be deployed to the deployment directory and bashrc file is updated or not.
Valid arguments are "present" or "absent".

Default is present.


####`source`

This parameter specifies the source for the maven archive. 
This file must be in the files directory in the caller module. 
**Only .tar.gz source archives are supported.**

####`deploymentdir`

This parameter specifies the directory where maven will be installed.

Warning: If deploymentdir is set to /usr/local/, and you want to remove this installation in the future, setting ensure => 'absent' will cause the entire directory, i. e. /usr/local/ to be deleted permanently. It is strongly recommended to set deploymentdir to some dedicated directory e.g /opt/apache-maven or /home/example.com/apps/apache-maven

####`user`

This parameter is used to set the permissions for the installation directory of maven.

####`pathfile`

This parameter is used to find and update the bashrc file to include maven in the environment path.


Limitations
------------

This module has been built and tested using Puppet 2.6.x, 2.7, and 3.x.

The module has been tested on:

* CentOS 5.9
* CentOS 6.4
* Debian 6.0 
* Ubuntu 12.04

Testing on other platforms has been light and cannot be guaranteed. 

Development
------------

Bug Reports
-----------

Release Notes
--------------
**0.0.3**

- Fixed issues with Modulefile and metadata.json

**0.0.2**

- Append maven bin path to beginning of PATH

**0.0.1**

- First initial release.
