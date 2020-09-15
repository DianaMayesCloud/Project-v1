# Public Access NACL AZ1
resource "aws_network_acl" "pub_az1_nacl" {
  vpc_id     = aws_vpc.green_vpc.id
  subnet_ids = [aws_subnet.pub_az1_subnet.id]
  tags = {
    Name = "Public-AZ1-NACL"
  }
}

resource "aws_network_acl" "pub_az2_nacl" {
  vpc_id     = aws_vpc.green_vpc.id
  subnet_ids = [aws_subnet.pub_az2_subnet.id]
  tags = {
    Name = "Public-AZ2-NACL"
  }
}

resource "aws_network_acl" "priv1_az1_nacl" {
  vpc_id     = aws_vpc.green_vpc.id
  subnet_ids = [aws_subnet.priv1_az1_subnet.id]
  tags = {
    Name = "Priv1-AZ1-NACL"
  }
}

resource "aws_network_acl" "priv1_az2_nacl" {
  subnet_ids = [aws_subnet.priv1_az2_subnet.id]
  vpc_id     = aws_vpc.green_vpc.id
  tags = {
    Name = "Priv1-AZ2-NACL"
  }
}

resource "aws_network_acl" "priv2_az1_nacl" {
  subnet_ids = [aws_subnet.priv2_az1_subnet.id]
  vpc_id     = aws_vpc.green_vpc.id
  tags = {
    Name = "DB-AZ1-NACL"
  }
}
resource "aws_network_acl" "priv2_az2_nacl" {
  subnet_ids = [aws_subnet.priv2_az2_subnet.id]
  vpc_id     = aws_vpc.green_vpc.id
  tags = {
    Name = "DB-AZ2-NACL"
  }
}
