#**********************************************************************************************************  
#                                           *  #Subnet - Public AZ2  *
#************************************************************************************************************


#************** AZ2 Inbound to Public Subnet ******************


# HTTP access from Everywhere 
resource "aws_network_acl_rule" "pub_az2_inbound_http" {
  network_acl_id = aws_network_acl.pub_az2_nacl.id
  rule_number    = 100
  egress         = false
  rule_action    = "allow"
  from_port      = 80
  to_port        = 80
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
}

#  HTTPS access from Everywhere
resource "aws_network_acl_rule" "pub_az2_inbound_https" {
  network_acl_id = aws_network_acl.pub_az2_nacl.id
  rule_number    = 110
  egress         = false
  rule_action    = "allow"
  from_port      = 443
  to_port        = 443
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"

}

# ssh access from Everywhere
resource "aws_network_acl_rule" "pub_az2_inbound_ssh" {
  network_acl_id = aws_network_acl.pub_az2_nacl.id
  rule_number    = 120
  egress         = false
  rule_action    = "allow"
  from_port      = 22
  to_port        = 22
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
}
#  MySQL access from Everywhere

resource "aws_network_acl_rule" "pub_az2_inbound_mysql" {
  network_acl_id = aws_network_acl.pub_az2_nacl.id
  rule_number    = 130
  egress         = false
  rule_action    = "allow"
  from_port      = 3306
  to_port        = 3306
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
}

# Custom: Allows Inbound Return traffic from hosts on the internet that are responding to requests originating in the subnet

resource "aws_network_acl_rule" "pub_az2_inbound_range" {
  network_acl_id = aws_network_acl.pub_az2_nacl.id
  rule_number    = 140
  egress         = false
  rule_action    = "allow"
  from_port      = 1024
  to_port        = 65535
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
}

# Ping access from Everywhere
resource "aws_network_acl_rule" "pub_az2_inbound_ping" {
  network_acl_id = aws_network_acl.pub_az2_nacl.id
  rule_number    = 150
  egress         = false
  protocol       = "icmp"
  icmp_type      = -1
  icmp_code      = -1
  from_port      = 0
  to_port        = 0
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}


#************** AZ2 Outbound from Public Subnet  ******************

resource "aws_network_acl_rule" "pub_az2_outbound_everwhere" {
  network_acl_id = aws_network_acl.pub_az2_nacl.id
  rule_number    = 100
  egress         = true
  rule_action    = "allow"
  from_port      = 0
  to_port        = 0
  protocol       = "-1"
  cidr_block     = "0.0.0.0/0"
}



#**********************************************************************************************************  
#                                           *  #Subnet - Private AZ2 (for web and application servers) *
#************************************************************************************************************

#************** AZ2 Inbound to Private1 Subnet ******************

# HTTP access from VPC         
resource "aws_network_acl_rule" "priv1_az2_inbound_http" {
  network_acl_id = aws_network_acl.priv1_az2_nacl.id
  rule_number    = 100
  egress         = false
  rule_action    = "allow"
  from_port      = 80
  to_port        = 80
  protocol       = "tcp"
  cidr_block     = "10.0.0.0/16"
}

# HTTPS access from VPC   
resource "aws_network_acl_rule" "priv1_az2_inbound_https" {
  network_acl_id = aws_network_acl.priv1_az2_nacl.id
  rule_number    = 120
  egress         = false
  rule_action    = "allow"
  from_port      = 443
  to_port        = 443
  protocol       = "tcp"
  cidr_block     = "10.0.0.0/16"
}


# ssh access from VPC   
resource "aws_network_acl_rule" "priv1_az2_inbound_ssh" {
  network_acl_id = aws_network_acl.priv1_az2_nacl.id
  rule_number    = 130
  egress         = false
  rule_action    = "allow"
  from_port      = 22
  to_port        = 22
  protocol       = "tcp"
  cidr_block     = "10.0.0.0/16"
}


#  MySQL port access from VPC   
resource "aws_network_acl_rule" "priv1_az2_inbound_mysql" {
  network_acl_id = aws_network_acl.priv1_az2_nacl.id
  rule_number    = 140
  egress         = false
  rule_action    = "allow"
  from_port      = 3306
  to_port        = 3306
  protocol       = "tcp"
  cidr_block     = "10.0.0.0/16"
}

# Custom: Allows Inbound Return traffic from hosts on the internet that are responding to requests originating in the subnet
resource "aws_network_acl_rule" "priv1_az2_inbound_range" {
  network_acl_id = aws_network_acl.priv1_az2_nacl.id
  rule_number    = 150
  egress         = false
  rule_action    = "allow"
  from_port      = 1024
  to_port        = 65535
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
}

# Ping access from VPC   
resource "aws_network_acl_rule" "priv1_az2_inbound_ping" {
  network_acl_id = aws_network_acl.priv1_az2_nacl.id
  rule_number    = 160
  egress         = false
  protocol       = "icmp"
  icmp_type      = -1
  icmp_code      = -1
  from_port      = 0
  to_port        = 0
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

#********** AZ2 Outbound from Private1 Subnet ( web and application Servers)  *************

# Outbound Everywhere
resource "aws_network_acl_rule" "priv1_az2_outbound_all" {
  network_acl_id = aws_network_acl.priv1_az2_nacl.id
  rule_number    = 100
  egress         = true
  rule_action    = "allow"
  from_port      = 0
  to_port        = 0
  protocol       = "-1"
  cidr_block     = "0.0.0.0/0"
}
#**********************************************************************************************************  
#                                           *  #Subnet - Private2 AZ2 (Database) *
#************************************************************************************************************

#*********  AZ2 Inbound to Database **********

# MySQL from Private1 Subnet (Web and Applications) AZ2

resource "aws_network_acl_rule" "priv2_az2_inbound_mysql1" {
  network_acl_id = aws_network_acl.priv2_az2_nacl.id
  rule_number    = 100
  egress         = false
  rule_action    = "allow"
  from_port      = 3306
  to_port        = 3306
  protocol       = "tcp"
  cidr_block     = "10.0.50.0/24"
}

# MySQL from Private1 Subnet (Web and Applications) AZ2

resource "aws_network_acl_rule" "priv2_az2_inbound_mysql2" {
  network_acl_id = aws_network_acl.priv2_az2_nacl.id
  rule_number    = 110
  egress         = false
  rule_action    = "allow"
  from_port      = 3306
  to_port        = 3306
  protocol       = "tcp"
  cidr_block     = "10.0.20.0/24"
}

#**********************************  Outbound from DB Subnet in AZ2  *********************************

resource "aws_network_acl_rule" "priv2_az2_outbound_mysql" {
  network_acl_id = aws_network_acl.priv2_az2_nacl.id
  rule_number    = 100
  egress         = true
  rule_action    = "allow"
  from_port      = 0
  to_port        = 0
  protocol       = "-1"
  cidr_block     = "0.0.0.0/0"
}