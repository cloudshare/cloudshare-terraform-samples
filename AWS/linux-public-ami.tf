# Change "instance_type" according to your needs
# Change "ci-key-username" to your  AMI username
# The "Name" tag will be the VM name as seen in the CloudShare viewer.

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}
resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name      = "cs-key"
  tags = {
    Name = "Ubuntu 14.04"
    ci-key-username = "ubuntu"
  }
}
