# ************** Public SG -- Access everywhere *********************
# Public Access SG 
resource "aws_security_group" "green_pub_sg" {
  name   = "GoGreen-Pub-SG"
  vpc_id = aws_vpc.green_vpc.id
  tags = {
    Name = "GoGreen-Pub-SG"
  }

  # Access from Anywhere
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Outbound to Anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ********************* Private SG for Web Servers *******************
# Access from everywhere through specific ports

resource "aws_security_group" "green_priv1_sg" {
  name   = "GoGreen-Priv1-SG"
  vpc_id = aws_vpc.green_vpc.id
  tags = {
    Name = "GoGreen-Priv2-SG"
  }

  # HTTP access from Anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from Anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ssh access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Custom access: Allows Inbound Return traffic from hosts on the internet that are responding to requests originating in the subnet
  ingress {
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ping access from Anywhere
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound to Anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ************************ Private SG for App Servers and DB -- Access from VPC *****************
# Private SG for DB Subnet
resource "aws_security_group" "green_priv2_sg" {
  name   = "GoGreen-Priv2-SG"
  vpc_id = aws_vpc.green_vpc.id
  tags = {
    Name = "GoGreen-Priv2-SG"
  }

  # Internal HTTP access from Public Subnet AZ1
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Internal HTTPS access from Public Subnet AZ1
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }


  #Internal ssh from Public Subnet AZ1
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Custom access AZ1: Allows Inbound Return traffic from hosts on the internet that are responding to requests originating in the subnet
  ingress {
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }


  # Internal MySQL port from Public Subnet AZ1
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ping access from everywhere
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outboung Everywhere

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}



