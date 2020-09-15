#Provision GreenPub-AZ2-Subnet in us-west-1a
resource "aws_subnet" "pub_az2_subnet" {
  vpc_id            = aws_vpc.green_vpc.id
  availability_zone = "us-west-1a"
  cidr_block        = "10.0.10.0/24"
  tags = {
    Name = "GreenPub-AZ2-Subnet"
  }
}

#Provision GreenPub-AZ1-Subnet in us-west-1b
resource "aws_subnet" "pub_az1_subnet" {
  vpc_id            = aws_vpc.green_vpc.id
  availability_zone = "us-west-1b"
  cidr_block        = "10.0.40.0/24"
  tags = {
    Name = "GreenPub-AZ1-Subnet"
  }
}

#Provision GreenPriv-AZ2-Subnet in us-west-1a
resource "aws_subnet" "priv1_az2_subnet" {
  vpc_id            = aws_vpc.green_vpc.id
  availability_zone = "us-west-1a"
  cidr_block        = "10.0.20.0/24"
  tags = {
    Name = "GreenPriv1-AZ2-Subnet"
  }
}

#Provision GreenPriv2-AZ1-Subnet in us-west-1b
resource "aws_subnet" "priv1_az1_subnet" {
  vpc_id            = aws_vpc.green_vpc.id
  availability_zone = "us-west-1b"
  cidr_block        = "10.0.50.0/24"
  tags = {
    Name = "GreenPriv1-AZ1-Subnet"
  }
}
#Provision GreenPriv2-AZ2-Subnet in us-west-1a
resource "aws_subnet" "priv2_az2_subnet" {
  vpc_id            = aws_vpc.green_vpc.id
  availability_zone = "us-west-1a"
  cidr_block        = "10.0.30.0/24"
  tags = {
    Name = "GreenPriv2-AZ2-Subnet"
  }
}

#Provision GreenPriv2-AZ1-Subnet in us-west-1b
resource "aws_subnet" "priv2_az1_subnet" {
  vpc_id            = aws_vpc.green_vpc.id
  availability_zone = "us-west-1b"
  cidr_block        = "10.0.60.0/24"
  tags = {
    Name = "GreenPriv2-AZ1-Subnet"
  }
}
