
provider "aws" {
  version = "~> 2.0"
  region = var.region
  access_key = var.awsAccessKey
  secret_key = var.awsSecretKey
}

variable "awsAccessKey" { }

variable "awsSecretKey" { }

variable "region" {
  default = "eu-west-1"
}


resource "aws_db_parameter_group" "edmm" {
  family = "mysql5.7"
  parameter {
    name  = "character_set_server"
    value = "utf8"
  }
  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

resource "aws_db_instance" "mysql_database" {
  name                 = "mysql_database"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "pc"
  password             = "petclinic"
  parameter_group_name = "edmm.mysql5.7"
}

resource "null_resource" "db_setup" {

    depends_on = ["aws_db_instance.mysql_database"]

    provisioner "remote-exec" {
        scripts = ["artifacttemplates/https%3A%2F%2Fedmm.uni-stuttgart.de%2Fartifacttemplates/MySQL_Database-Configure/files/configure.sh"]
        environment {
            MYSQL_SCHEMA_PATH = "artifacttemplates/https%3A%2F%2Fedmm.uni-stuttgart.de%2Fartifacttemplates/Petclinic-Schema/files/schema.sql"
            MYSQL_DBMS_ENDPOINT = aws_db_instance.mysql_database.endpoint
            MYSQL_DBMS_PORT = aws_db_instance.mysql_database.port
            MYSQL_DATABASE_USER = aws_db_instance.mysql_database.username
            MYSQL_DBMS_ROOT_PASSWORD = aws_db_instance.mysql_database.password
        }
   }
}


resource "aws_s3_bucket" "bucket_petclinic" {
  bucket = "edmm_application_bucket_petclinic"
}

resource "aws_s3_bucket_object" "bucket_object_petclinic" {
  bucket = aws_s3_bucket.bucket_petclinic.id
  key    = "petclinic/petclinic.war"
  source = "artifacttemplates/https%3A%2F%2Fedmm.uni-stuttgart.de%2Fartifacttemplates/PetClinic-App/files/petclinic.war"
}

resource "aws_elastic_beanstalk_application" "app_petclinic" {
  name        = "petclinic"
  description = "Application created by Terraform"
}

resource "aws_elastic_beanstalk_application_version" "app_petclinic_version" {
  name        = "petclinic_v1.0.0"
  application = "petclinic"
  description = "Application version created by Terraform"
  bucket      = aws_s3_bucket.bucket_petclinic.id
  key         = aws_s3_bucket_object.bucket_object_petclinic.id
}


