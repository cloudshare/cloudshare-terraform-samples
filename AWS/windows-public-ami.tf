# Change "instance_type" according to your needs
# The "Name" tag will be the VM name as seen in the CloudShare viewer.

data "aws_ami" "Windows_2022" {
    filter {
        name = "is-public"
        values = ["true"]
    }
    filter {
        name = "name"
        values = ["Windows_Server-2022-English-Full-Base-*"]
    }
    most_recent = true
    owners = ["amazon"]
}
resource "aws_instance" "win-example" {
  ami           = "${data.aws_ami.Windows_2022.id}"
  instance_type = "t2.micro"
  key_name      = "cs-key"
  tags = {
    Name = "Windows_Server"
  }
}
