#Provision vpc, subnets, igw, and default route-table
#1 VPC - 6 subnets (public, app, database)
#provision app vpc
resource "aws_vpc" "green_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "GoGreenVPC"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "green_igw" {
  vpc_id = aws_vpc.green_vpc.id
  tags = {
    Name = "GoGreenIGW"
  }
}

# Create NAT EIP
resource "aws_eip" "green_nat_eip" {
  vpc = true
  associate_with_private_ip = "10.0.40.0"
}
# Create NAT Gateway
resource "aws_nat_gateway" "green_nat_gw" {
  allocation_id = aws_eip.green_nat_eip.id
  subnet_id     = aws_subnet.pub_az1_subnet.id
  depends_on    = [aws_eip.green_nat_eip]
  tags = {
    Name = "Green-Nat-GW"
  }
}

# Create Public Route Table 
resource "aws_route_table" "green_pub_rt" {
  vpc_id = aws_vpc.green_vpc.id
  tags = {
    Name = "GreenPublic-Route-Table"
  }
}

# Create Private Route Table 
resource "aws_route_table" "green_private_rt" {
  vpc_id = aws_vpc.green_vpc.id
  tags = {
    Name = "GreenPrivate-Route-Table",
  }
}

# Create Public Route 
resource "aws_route" "green_pub_route" {
  route_table_id         = aws_route_table.green_pub_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.green_igw.id
}

# Create Private Route
resource "aws_route" "green_private_route" {
  route_table_id         = aws_route_table.green_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id             = aws_nat_gateway.green_nat_gw.id
}

# Make "green_default" Public Route Table your Main Route Table (rather than the one automatically created by AWS when launching the VPC)
resource "aws_main_route_table_association" "green_default" {
  vpc_id         = aws_vpc.green_vpc.id
  route_table_id = aws_route_table.green_pub_rt.id
}

#Associate Public route table with the Public Subnets 
resource "aws_route_table_association" "pub_subassocaz1" {
  route_table_id = aws_route_table.green_pub_rt.id # associate this public RT
  subnet_id      = aws_subnet.pub_az1_subnet.id   # with this Public Subnet in AZ1
}

resource "aws_route_table_association" "pub_subassocaz2s" {
  route_table_id = aws_route_table.green_pub_rt.id # associate this public RT 
  subnet_id      = aws_subnet.pub_az2_subnet.id   # with this Public Subnet in AZ1
}

#Associate Private Route Table with the Private Subnets 
resource "aws_route_table_association" "priv1_az1_sub_assoc" {
  route_table_id = aws_route_table.green_private_rt.id
  subnet_id      = aws_subnet.priv1_az1_subnet.id
}

resource "aws_route_table_association" "priv1_az2_sub_assoc" {
  route_table_id = aws_route_table.green_private_rt.id
  subnet_id      = aws_subnet.priv1_az2_subnet.id
}

resource "aws_route_table_association" "priv2_az1_sub_assoc" {
  route_table_id = aws_route_table.green_private_rt.id
  subnet_id      = aws_subnet.priv2_az1_subnet.id
}

resource "aws_route_table_association" "priv2_az2_sub_assoc" {
  route_table_id = aws_route_table.green_private_rt.id
  subnet_id      = aws_subnet.priv2_az2_subnet.id
}

# Create Instance in the Public Subnet
resource "aws_instance" "green_bastion" {
  ami                         = "ami-023e0c35fc414e78b"
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.pub_az1_subnet.id
  security_groups             = [aws_security_group.green_pub_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name
  #aws_key_pair  = aws_key_pair.deployer
  user_data                   = file("app_userdata.sh")
  tags = {
    Name = "Green-Bastion"
  }
}

# resource "aws_key_pair" "deployer" {
#   key_name   = "deployer-key"
#   public_key = var.deployer
# }

# # Create Instance in the Private Subnet 
# resource "aws_instance" "green_private_ec2" {
#   ami                         = "ami-02354e95b39ca8dec"
#   instance_type               = "t2.micro"
#   subnet_id                   = aws_subnet.priv1_az1_subnet.id
#   security_groups             = [aws_security_group.green_priv1_sg.id]
#   associate_public_ip_address = true
#   key_name                    = var.key_name
#   user_data                   = file("userdata.sh")
#   tags = {
#     Name = "Green-Private-ec2"
#   }
# } 



# resource "aws_eip_association" "eip_assoc" {
#   instance_id   = aws_instance.green_private_ec2.id
#   allocation_id = aws_eip.example.id
# }


