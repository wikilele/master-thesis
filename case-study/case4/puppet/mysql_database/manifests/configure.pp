class mysql_database::configure {
  file { 'configure.sh':
    ensure => 'file',
    source => 'puppet:///modules/mysql_database/configure.sh',
    path => '/usr/local/bin/configure.sh',
    owner => 'root'
    group => 'root'
    mode  => '0744', # Use 0700 if it is sensitive
    notify => Exec['run_configure.sh'],
  }
  exec { 'run_configure.sh':
    environment => [
        'mysql_database_password=petclinic',
        'mysql_database_schema_name=petclinic',
        'mysql_database_user=pc',
        'mysql_dbms_port=3306',
        'mysql_dbms_root_password=petclinic',
        'compute_2_os_family=',
        'compute_2_machine_image=',
        'compute_2_instance_type='
    ],
    command => '/usr/local/bin/configure.sh',
    refreshonly => true
  }
}
