class mysql_dbms::create {
  file { 'create.sh':
    ensure => 'file',
    source => 'puppet:///modules/mysql_dbms/create.sh',
    path => '/usr/local/bin/create.sh',
    owner => 'root'
    group => 'root'
    mode  => '0744', # Use 0700 if it is sensitive
    notify => Exec['run_create.sh'],
  }
  exec { 'run_create.sh':
    environment => [
        'mysql_dbms_port=3306',
        'mysql_dbms_root_password=petclinic',
        'compute_2_os_family=',
        'compute_2_machine_image=',
        'compute_2_instance_type='
    ],
    command => '/usr/local/bin/create.sh',
    refreshonly => true
  }
}
