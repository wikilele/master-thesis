class mysql_dbms::start {
  file { 'start.sh':
    ensure => 'file',
    source => 'puppet:///modules/mysql_dbms/start.sh',
    path => '/usr/local/bin/start.sh',
    owner => 'root'
    group => 'root'
    mode  => '0744', # Use 0700 if it is sensitive
    notify => Exec['run_start.sh'],
  }
  exec { 'run_start.sh':
    environment => [
        'mysql_dbms_port=3306',
        'mysql_dbms_root_password=petclinic',
        'compute_2_os_family=',
        'compute_2_machine_image=',
        'compute_2_instance_type='
    ],
    command => '/usr/local/bin/start.sh',
    refreshonly => true
  }
}
