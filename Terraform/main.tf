provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "task1-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
  "Name" = "task1-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "task1-subnet" {
  vpc_id     = aws_vpc.task1-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
  "Name" = "task1-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "task1-igw" {
  vpc_id = aws_vpc.task1-vpc.id
  tags = {
  "Name" = "task1-igw"
  }
}

# Route Table
resource "aws_route_table" "task1-rt" {
  vpc_id = aws_vpc.task1-vpc.id
  tags = {
  "Name" = "task1-rt"
  }
}

# Add route to Internet Gateway
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.task1-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.task1-igw.id
}

# Route Table Association
resource "aws_route_table_association" "task1-rta" {
  subnet_id      = aws_subnet.task1-subnet.id
  route_table_id = aws_route_table.task1-rt.id
}

# Security Group
resource "aws_security_group" "task1-sg" {
  description = "Allow HTTP, SSH inbound traffic"
  vpc_id = aws_vpc.task1-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
    Name = "task1-sg"
  }
}

# EC2 Instance
resource "aws_instance" "task1-ws" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.task1-subnet.id
  vpc_security_group_ids = [aws_security_group.task1-sg.id]

  user_data = file("install_apache.sh")

  tags = {
  Name = "task1-ws"
  }
}

# Elastic IP for Public Access
resource "aws_eip" "task1-eip" {
  instance = aws_instance.task1-ws.id
}