variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_name" {}
variable "aws_key_path" {}
variable "aws_region" {}

variable "aws_ami" {}

variable "aws_instance_type" {
    default = "t2.micro"
}
