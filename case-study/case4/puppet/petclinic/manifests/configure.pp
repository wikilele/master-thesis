class petclinic::configure {
  file { 'configure.sh':
    ensure => 'file',
    source => 'puppet:///modules/petclinic/configure.sh',
    path => '/usr/local/bin/configure.sh',
    owner => 'root'
    group => 'root'
    mode  => '0744', # Use 0700 if it is sensitive
    notify => Exec['run_configure.sh'],
  }
  exec { 'run_configure.sh':
    environment => [
        'tomcat_port=8080',
        'compute_os_family=linux',
        'compute_machine_image=ubuntu',
        'compute_instance_type=large'
    ],
    command => '/usr/local/bin/configure.sh',
    refreshonly => true
  }
}
