provider "aws" {
  region     = "us-west-2"
  access_key = ""
  secret_key = ""
}
resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "my-subnet"
  }
}
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-igw"
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

}
resource "aws_security_group" "allow_TLS" {
  name        = "allow-TLS"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_block = {
   default = "10.0.0.0/16"
}
   #ipv6_cidr_blocks = "aws_vpc.my_vpc.ipv6_cidr_block"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_route_table_association" "my_rt_ass" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_instance" "my_class_server" {
  ami           = "ami-0ee8244746ec5d6d4"
  instance_type = "t2.micro"
  key_name      = "class-key"
  tags = {
    Name = "my-class-server"
  }
}
resource "aws_s3_bucket" "my_tf_b" {
  bucket = "my-tf-test-b"

  tags = {
    Name        = "My-tf-test-b"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_acl" "acl_tf_b" {
  bucket = aws_s3_bucket.my_tf_b.id
  acl    = "public-read"
}
