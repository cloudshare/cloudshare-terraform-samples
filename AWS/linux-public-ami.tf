# Change "instance_type" according to your needs
# Change "ci-key-username" to your  AMI username
# The "Name" tag will be the VM name as seen in the CloudShare viewer.

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
  instance_type = "t2.small"
  key_name      = "cs-key"
  tags = {
    Name = "Ubuntu 24.04"
    ci-key-username = "ubuntu"
  }
}
