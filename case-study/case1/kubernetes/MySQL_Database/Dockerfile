FROM library/ubuntu:bionic
ENV OS_FAMILY=
ENV MACHINE_IMAGE=
ENV INSTANCE_TYPE=
ENV ROOT_PASSWORD=petclinic
ENV PORT=3306
ENV MYSQL_ROOT_PASSWORD=petclinic
ENV SCHEMA_NAME=petclinic
ENV PASSWORD=petclinic
ENV USER=pc
ENV MYSQL_DATABASE=petclinic
ENV MYSQL_USER=pc
ENV MYSQL_PASSWORD=petclinic
ENV MYSQL_ALLOW_EMPTY_PASSWORD=yes
WORKDIR /opt/MySQL_Database
ADD ./schema.sql schema.sql
ADD ./mysql_dbms_create.sh mysql_dbms_create.sh
ADD ./mysql_database_configure.sh mysql_database_configure.sh
ADD ./mysql_dbms_start.sh mysql_dbms_start.sh
RUN ./mysql_dbms_create.sh && \
    ./mysql_database_configure.sh
EXPOSE 3306
CMD ["./mysql_dbms_start.sh"]

