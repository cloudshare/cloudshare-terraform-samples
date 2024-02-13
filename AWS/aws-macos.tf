resource "aws_ec2_host" "example_host" {
  instance_type     = "mac2-m2.metal"
  availability_zone = "eu-central-1a"
}

resource "aws_instance" "example_instance" {
  ami           = data.aws_ami.mac2-m2-ami.id
  host_id       = aws_ec2_host.example_host.id
  instance_type = "mac2-m2.metal"
  iam_instance_profile = var.CS_AWS_SSM_Instance_Profile_Name
  key_name      = "cs-key"
  tags = {
    Name = "macOS"
  }
}

data "aws_ami" "mac2-m2-ami" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn-ec2-macos-13.6.3*"]
  }
}
