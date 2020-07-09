class tomcat::create {
  file { 'create.sh':
    ensure => 'file',
    source => 'puppet:///modules/tomcat/create.sh',
    path => '/usr/local/bin/create.sh',
    owner => 'root'
    group => 'root'
    mode  => '0744', # Use 0700 if it is sensitive
    notify => Exec['run_create.sh'],
  }
  exec { 'run_create.sh':
    environment => [
        'tomcat_port=8080',
        'compute_os_family=linux',
        'compute_machine_image=ubuntu',
        'compute_instance_type=large'
    ],
    command => '/usr/local/bin/create.sh',
    refreshonly => true
  }
}
