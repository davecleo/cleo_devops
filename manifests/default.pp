$harmony_dir='/home/harmony'
$harmony_user='harmony'
$harmony_group='harmony'

include wget


user { $harmony_user:
        ensure => 'present',
        home => $harmony_dir,
        managehome => true,
}

group { $harmony_group:
              ensure => 'present',
              gid    => '502',
     }

exec { "apt-get update":
  path => "/usr/bin",
}

package {"unzip":
    ensure => "installed"
}

package {"rng-tools":
    ensure => "installed"
}

class {'mysql::server':
        root_password   => 'harmony'
}

mysql::db {'harmony':
    user    => 'harmony',
    password    => 'harmony'
}

if $ec2_instance_id {
  wget::fetch { "download harmony":
     source => 'http://www.cleo.com/SoftwareUpdate/harmony/release/jre1.8/InstData/Linux(64-bit)/VM/install.bin',
     destination => '/tmp/install.bin',
     notify => Exec["run harmony installer"]
 }
} else {
  file {"get harmony installer":
     path => '/tmp/install.bin',
     source => '/vagrant/installers/Harmony.bin',
     ensure => 'present',
     notify => Exec["run harmony installer"]
  }
}

wget::fetch { "download service wrapper":
    source => "https://raw.githubusercontent.com/jthielens/versalex-ops/master/service/cleo-service",
    destination => "/usr/local/bin/cleo-service",
}

file { "service installer":
    path => '/usr/local/bin/cleo-service', 
    ensure => 'present', 
    mode => '0700',
    require => Wget::Fetch['download service wrapper'],
}
    
file { "harmony license":
    path => '/home/harmony/license_key.txt',
    ensure => 'present',
    source => '/vagrant/license_key.txt',
}

exec { "install service":
  command => "cleo-service install /home/harmony cleod 2>&1 > /tmp/install.out",
  path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin",
  require => [ File['/usr/local/bin/cleo-service'], Exec ['run harmony installer']],
}

exec { "make_unify_repos":
    command => "mkdir -p ${harmony_dir}/repos/unify; mkdir -p ${harmony_dir}/repos/unify_over; mkdir -p ${harmony_dir}/repos/trust; mkdir -p ${harmony_dir}/repos/trust_over; rngd -r /dev/urandom",
    path    => "/usr/bin/:/bin/:/usr/sbin",
    require => [ Exec['run harmony installer'],
                 Package['rng-tools']
        ]
}

wget::fetch {"download sql driver":
    source => 'http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.24.zip',
    destination => '/tmp/mysql.zip',
    notify => Exec["extract_mysql_jar"]
}

exec { "extract_mysql_jar":
    command => "unzip -o /tmp/mysql.zip -d /tmp;
                mv /tmp/mysql-connector-java-5.1.24/mysql-connector-java-5.1.24-bin.jar ${harmony_dir}/lib/ext",
    path    => "/usr/bin/:/bin/",
    require => [ Package['unzip'],
                 Exec['run harmony installer'] ,
        ]
}

exec { 'run harmony installer':
  path => '/bin/',
  command => "sh /tmp/install.bin -i silent -DUSER_INSTALL_DIR=${harmony_dir}",
  # command => "sh /vagrant/Harmony.bin -i silent -DUSER_INSTALL_DIR=${harmony_dir}",
  user => $harmony_user,
  creates => "${harmony_dir}/Harmonyd"
}

service {"cleod":
    ensure => "running",
    require => [ Exec["install service"], File["harmony license"] ],
}
