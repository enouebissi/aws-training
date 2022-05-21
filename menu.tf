provider "aws" {
  region = us-west-2
}
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.1.0/24"
}
