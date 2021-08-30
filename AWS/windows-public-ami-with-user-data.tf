# Change "instance_type" according to your needs
# The "Name" tag will be the VM name as seen in the CloudShare viewer.

data "aws_ami" "Windows_2019" {
    filter {
        name = "is-public"
        values = ["true"]
    }
    filter {
        name = "name"
        values = ["Windows_Server-2019-English-Full-Base-*"]
    }
    most_recent = true
    owners = ["amazon"]
}

resource "aws_instance" "win-example" {
  ami           = "${data.aws_ami.Windows_2019.id}"
  instance_type = "t2.micro"
  key_name      = "cs-key"
  tags = {
    Name = "Windows_Server"
  }
  user_data = <<EOF
<powershell>
New-Item -Path "C:\" -Name "OutputDir" -ItemType "directory"
New-Item -Path "C:\OutputDir" -Name "test.txt" -ItemType "file" -Value "This is a text string."
</powershell>

EOF
}
