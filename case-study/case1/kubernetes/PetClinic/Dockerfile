FROM library/ubuntu:bionic
ENV OS_FAMILY=linux
ENV MACHINE_IMAGE=ubuntu
ENV INSTANCE_TYPE=large
ENV PORT=8080
WORKDIR /opt/PetClinic
ADD ./petclinic.war petclinic.war
ADD ./tomcat_create.sh tomcat_create.sh
ADD ./petclinic_configure.sh petclinic_configure.sh
ADD ./petclinic_start.sh petclinic_start.sh
RUN ./tomcat_create.sh && \
    ./petclinic_configure.sh
EXPOSE 8080
CMD ["./petclinic_start.sh"]

