provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "task1-vpc" {
  cidr_block = "10.0.0.0/16"
}

# Public Subnet
resource "aws_subnet" "task1-subnet" {
  vpc_id     = aws_vpc.task1-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# Internet Gateway
resource "aws_internet_gateway" "task1-igw" {
  vpc_id = aws_vpc.task1-vpc.id
}

# Route Table
resource "aws_route_table" "task1-rt" {
  vpc_id = aws_vpc.task1-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.task1-igw.id
  }
}

# Route Table Association
resource "aws_route_table_association" "task1-rta" {
  subnet_id      = aws_subnet.task1-subnet.id
  route_table_id = aws_route_table.task1-rt.id
}