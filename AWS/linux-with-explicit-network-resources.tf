# Change "instance_type" according to your needs
# Change "ci-key-username" to your  AMI username
# The "Name" tag will be the VM name as seen in the CloudShare viewer.

# Please contact CloudShare support for our SSH\RDP proxy servers

resource "aws_vpc" "main" {
  cidr_block       = "172.31.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "sn_public" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "172.31.16.0/20"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_security_group" "my_sg" {
  name        = "my_sg"
  description = "my_sg_description"
  vpc_id = "${aws_vpc.main.id}"
  # CloudShare automatically adds the remote access gateway ingress and egress rules to allow SSH and RDP to the instnaces from the viewer.
  # So we can keep the ingress list empty.
  ingress = []
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.my_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"
  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  tags = {
    Name = "main"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.sn_public.id}"
  route_table_id = "${aws_route_table.r.id}"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] 
}

resource "aws_instance" "Ubuntu" {
  ami           = "${data.aws_ami.ubuntu.id}"
  vpc_security_group_ids = [ "${aws_security_group.my_sg.id}" ]
  subnet_id = "${aws_subnet.sn_public.id}"
  instance_type = "t2.small"
  key_name      = "cs-key"
  tags = {
    Name = "Ubuntu 24.04"
    ci-key-username = "ubuntu"
  }
}
