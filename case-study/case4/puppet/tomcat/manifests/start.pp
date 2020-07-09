class tomcat::start {
  file { 'start.sh':
    ensure => 'file',
    source => 'puppet:///modules/tomcat/start.sh',
    path => '/usr/local/bin/start.sh',
    owner => 'root'
    group => 'root'
    mode  => '0744', # Use 0700 if it is sensitive
    notify => Exec['run_start.sh'],
  }
  exec { 'run_start.sh':
    environment => [
        'tomcat_port=8080',
        'compute_os_family=linux',
        'compute_machine_image=ubuntu',
        'compute_instance_type=large'
    ],
    command => '/usr/local/bin/start.sh',
    refreshonly => true
  }
}
