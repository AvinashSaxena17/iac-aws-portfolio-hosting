#VPC
resource "aws_vpc" "my_vpc" {
  cidr_block       = "10.0.0.0/16"
 

  tags = {
    Name = "prod : VPC"
  }
}

#subnet 
resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"


  tags = {
    Name = "prod : public-subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "prod : public-subnet-2"
  }
}

#internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "prod: igw"
  }
}

#Route table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "prod : route-table"
  }
}

#Route-table Public-Subnet-1 Associattion
resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.route_table.id
}

#Route-table Public-Subnet-2 Associattion
resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.route_table.id
}

