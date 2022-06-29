resource "aws_security_group" "my_sg" {
  name        = "my_sg"
  description = "my_sg_description"
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
  security_groups = ["${aws_security_group.my_sg.name}"]
  instance_type = "t2.micro"
  key_name      = "cs-key"
  tags = {
    Name = "Ubuntu 20.04"
    ci-key-username = "ubuntu"
  }
}
