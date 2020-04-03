provider "aws" {

    region = "us-east-1"

}

#VPC AIK
resource "aws_vpc" "aik-vpc"{

    cidr_block = "${var.vpc-cidr}"

    tags {
        Name = "${var.vpc-name}"
    }
}

#IGW 
resource "aws_internet_gateway" "aik-igw" {

    vpc_id = "${aws_vpc.aik-vpc.id}"
}

#Create public route table
resource "aws_route_table" "rtb-public" {
    vpc_id = "${aws_vpc.aik-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.aik-igw.id}"
    }

    tags {
        Name = "public"
    }

}

#Create and associate public subnets with a route table
resource "aws_subnet" "aik-subnet-public"{

  vpc_id = "${aws_vpc.aik-vpc.id}"
  cidr_block = "${cidrsubnet(var.vpc-cidr, 8, 1)}"
  availability_zone = "${element(split(",",var.aws-availability-zones), count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name = "Public"
  }
}

resource "aws_route_table_association" "public" {

    subnet_id = "${aws_subnet.aik-subnet-public.id}"
    route_table_id = "${aws_route_table.rtb-public.id}"
  
}

resource "aws_security_group" "aik-sg-portal" {

    name = "portal"
    description = "Sg for allow traffic to portal"
    vpc_id = "${aws_vpc.aik-vpc.id}"

    ingress {
        from_port = "3030"
        to_port = "3030"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = "22"
        to_port = "22"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
}

resource "aws_instance" "aik-portal" {

    ami = "${var.aik-ami-id}"
    instance_type = "${var.aik-instance-type}"
    key_name = "${var.aik-key-name}"
    vpc_security_group_ids = ["${aws_security_group.aik-sg-portal.id}"]
    subnet_id = "${aws_subnet.aik-subnet-public.id}"
    tags { Name = "Aik portal - JSGD" }

    user_data = <<-EOF

        #!/bin/bash
        sudo yum update -y
        sudo yum install -y git 
        #Clone salt repo
        git clone https://github.com/icesi-ops/training_IaC /srv/Configuration_management

        #Install Salstack
        sudo yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest.el7.noarch.rpm
        sudo yum clean expire-cache;sudo yum -y install salt-minion; chkconfig salt-minion off

        #Put custom minion config in place (for enabling masterless mode)
        sudo cp -r /srv/Configuration_management/SaltStack/minion.d /etc/salt/
        echo -e 'grains:\n roles:\n  - frontend' > /etc/salt/minion.d/grains.conf

        ## Trigger a full Salt run
        sudo salt-call state.apply

        EOF
  
}






