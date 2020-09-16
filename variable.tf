variable "availability_zones" {
  default     = "us-west-1a,us-west-1b"
  description = "List of availability zones"
}

variable "key_name" {
  description = "Name of key pair"
  default     = "cali-key1"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

