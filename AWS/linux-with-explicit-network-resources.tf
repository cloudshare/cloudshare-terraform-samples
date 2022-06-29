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
  ingress {
        from_port   = 3389
        to_port     = 3389
        protocol    = "TCP"
        cidr_blocks = ["<CloudShare RDP Proxy Server 1>/32"]
   }
     ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "TCP"
        cidr_blocks = ["<CloudShare SSH Proxy Server 1>/32"]
   }
  ingress {
        from_port   = 3389
        to_port     = 3389
        protocol    = "TCP"
        cidr_blocks = ["<CloudShare RDP Proxy Server 2>/32"]
   }
     ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "TCP"
        cidr_blocks = ["<CloudShare SSH Proxy Server 2>/32"]
   }
  egress {
    description = "TCP ALL"
    from_port   = 0
    to_port     = 0   
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self = true
  }
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
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}
resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  #security_groups = ["${aws_security_group.my_sg.name}"]
  vpc_security_group_ids = [ "${aws_security_group.my_sg.id}" ]
  subnet_id = "${aws_subnet.sn_public.id}"
  instance_type = "t2.micro"
  key_name      = "cs-key"
  tags = {
    Name = "Ubuntu 20.04"
    ci-key-username = "ubuntu"
  }
}
