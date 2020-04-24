variable "aik-ami-id" {
  description = "AMI ID used for apply to instance's AIK"
  default = "ami-0fc61db8544a617ed"

}

variable "vpc-cidr" {
  description = "VPC cidr to use for AIK VPC"
  default = "10.0.0.0/16"
}

variable "vpc-name" {
  description = "Name VPC of AIK"
  default = "aik-vpc"
}

variable "aws-availability-zones" {
  description = "availability zones to uses for AIK"
  default = "us-east-1a,us-east-1b"
}

variable "aik-instance-type" {
  description = "type of instance for use with instances of FRONT AND BACK"
  default = "t2.micro"
}

variable "aik-key-name" {
  description = "Key pair name"
  default = "devops"
}
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = "string"
  default     = "3030"
}

variable "alb_name" {
  description = "The name of the ALB"
  type        = "string"
  default     = "alb_aik"
}

variable "instance_security_group_name" {
  description = "The name of the security group for the EC2 Instances"
  type        = "string"
  default     = "instances_sg"
}

variable "alb_security_group_name" {
  description = "The name of the security group for the ALB"
  type        = "string"
  default     = "alb_sg"
}
