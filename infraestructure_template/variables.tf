variable "aik-ami-id" {
    default = "ami-0fc61db8544a617ed"
  
}

variable "vpc-cidr"{
    default = "10.0.0.0/16"
}

variable "vpc-name"{
    default = "aik-vpc"
}

variable "aws-availability-zones"{
    default = "us-east-1a,us-east-1b"
}

variable "aik-instance-type" {
    default = "t2.micro"
}

variable "aik-key-name"{
    default = "devops"
}
