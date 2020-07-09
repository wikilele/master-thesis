#!/bin/bash
set -e
echo export MYSQL_DATABASE_USER=${MYSQL_DATABASE_USER} >> /etc/environment
echo export MYSQL_DBMS_PORT=${MYSQL_DBMS_PORT} >> /etc/environment
echo export MYSQL_DATABASE_SCHEMA_NAME=${MYSQL_DATABASE_SCHEMA_NAME} >> /etc/environment
echo export COMPUTE_2_OS_FAMILY=${COMPUTE_2_OS_FAMILY} >> /etc/environment
echo export COMPUTE_2_INSTANCE_TYPE=${COMPUTE_2_INSTANCE_TYPE} >> /etc/environment
echo export MYSQL_DBMS_ROOT_PASSWORD=${MYSQL_DBMS_ROOT_PASSWORD} >> /etc/environment
echo export COMPUTE_2_MACHINE_IMAGE=${COMPUTE_2_MACHINE_IMAGE} >> /etc/environment
echo export MYSQL_DATABASE_PASSWORD=${MYSQL_DATABASE_PASSWORD} >> /etc/environment
