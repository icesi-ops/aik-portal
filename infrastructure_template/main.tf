provider "aws" {
  region = "us-east-2"
}

#VPC

data "aws_vpc" "aik-vpc" {
  id = "vpc-025ce59ecf7aed804"
}

#IGW
data "aws_internet_gateway" "aik-igw" {
  internet_gateway_id = "igw-097d3d1e5513c7338"
}

#CRREATE PUBLIC ROUTE TABLE

resource "aws_route_table" "rtb-public" {
  vpc_id = data.aws_vpc.aik-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.aik-igw.id
  }

  tags = {
    Name = "automatizacion-est10-publicrtb"
  }
}

#Create and associate public subnets with a route table

resource "aws_subnet" "aik-subnet-public1" {

  vpc_id                  = data.aws_vpc.aik-vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 1)
  availability_zone       = element(split(",", var.aws_availability_zones), 0)
  map_public_ip_on_launch = true

  tags = {
    Name = "automatizacion-est10-subPUblic1"
  }

}

resource "aws_subnet" "aik-subnet-public2" {

  vpc_id                  = data.aws_vpc.aik-vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 3)
  availability_zone       = element(split(",", var.aws_availability_zones), 1)
  map_public_ip_on_launch = true

  tags = {
    Name = "automatizacion-est10-subPUblic2"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.aik-subnet-public1.id
  route_table_id = aws_route_table.rtb-public.id
}
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.aik-subnet-public2.id
  route_table_id = aws_route_table.rtb-public.id
}

resource "aws_security_group" "aik-sg-portal" {

  name        = "frontend"
  description = "Sf for allow traffic to portal frontend"
  vpc_id      = data.aws_vpc.aik-vpc.id

  ingress {
    from_port  = "3030"
    to_port    = "3030"
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port  = "22"
    to_port    = "22"
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_autoscaling_group" "aik_autoscaling" {
  launch_configuration = aws_launch_configuration.aik-lcfg.name
  min_size             = 2
  max_size             = 2
  vpc_zone_identifier  = [aws_subnet.aik-subnet-public1.id, aws_subnet.aik-subnet-public2.id]
  health_check_grace_period = 300
  health_check_type         = "EC2"
  target_group_arns         = ["${aws_lb_target_group.asg.arn}"]

  tag {
    key                 = "Name"
    value               = "automatizacion-est10-asg"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "aik-lcfg" {
  name            = "placeholder"
  image_id        = var.aik_ami_id
  instance_type   = var.aik_instance_type
  security_groups = [aws_security_group.aik-sg-portal.id]
  key_name        = var.aik_key_name
  user_data       = <<EOF

        #!/bin/bash
        sudo yum update -y
        sudo yum install -y git 
        #Clone salt repo
        mkdir -p /srv/app
        sudo chmod 777 /srv/app
        git clone https://github.com/icesi-ops/aik-portal /srv/app

        #Install Salstack
        sudo yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest.el7.noarch.rpm
        sudo yum clean expire-cache;sudo yum -y install salt-minion; chkconfig salt-minion off

        #Put custom minion config in place (for enabling masterless mode)
        sudo cp -r /srv/app/configuration_management/minion.d /etc/salt/
        echo -e 'grains:\n roles:\n  - frontend' > /etc/salt/minion.d/grains.conf

        ## Trigger a full Salt run
        sudo salt-call state.apply
        EOF
}

#Create Application Load Balancer
resource "aws_security_group" "sg_lb" {

  name   = var.alb_security_group_name
  vpc_id = data.aws_vpc.aik-vpc.id

  # Allow inbound HTTP requests
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "aik_lb" {

  name               = var.alb_name
  load_balancer_type = "application"
  subnets            = [aws_subnet.aik-subnet-public1.id, aws_subnet.aik-subnet-public2.id]
  security_groups    = ["${aws_security_group.sg_lb.id}"]

}

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.aik_lb.arn
  port              = 80
  protocol          = "HTTP"


  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }

  }

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.asg.arn}"
  }

}

resource "aws_lb_target_group" "asg" {

  name     = var.alb_name
  port     = "${var.server_port}"
  protocol = "HTTP"
  vpc_id   = "${data.aws_vpc.aik-vpc.id}"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 60
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

}
