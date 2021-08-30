# Change "instance_type" according to your needs
# Change "ci-key-username" to your AMI username
# The "Name" tag will be the VM name as seen in the CloudShare viewer.

resource "aws_instance" "web" {
  ami           = "ami-0c2b8ca1dad447f8a" #Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = "cs-key"

  user_data = <<EOF
    #! /bin/bash
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd
    sudo echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
  EOF

  tags = {
    Name = "Amazon-Linux-2"
    ci-key-username = "ec2-user"
  }
}
