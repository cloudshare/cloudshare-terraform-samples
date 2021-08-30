# Change the AMI ID
# Change instance_type according to your needs
# Change "ci-key-username" to your AMI username
# The "Name" tag will be the VM name as seen in the CloudShare viewer

resource "aws_instance" "instance_example" {
  ami = "ami-12345678abcdefghi"
  instance_type = "t2.micro"
  key_name = "cs-key"
  tags = {
    Name = "my-ec2-instance"
    ci-key-username = "ubuntu"
 }
}
