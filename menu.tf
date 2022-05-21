provider "aws" {
  region = "us-west-2"
}
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "my-vpc"
  }
}
resource "aws_subnet" "my_sbnt" {
  cidr_block = "10.0.1.0/25"
  vpc_id     = aws_vpc.my_vpc.id
  tags = {
    "Name" = "my-sbnt"
  }
}