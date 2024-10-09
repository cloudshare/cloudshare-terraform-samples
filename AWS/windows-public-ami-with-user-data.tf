# Change "instance_type" according to your needs
# The "Name" tag will be the VM name as seen in the CloudShare viewer.
#
# For custom Windows AMIs please run the following command on your AMI:
# C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\InitializeInstance.ps1 -Schedule
# see https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/ec2-windows-user-data.html

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
<persist>true</persist>
<powershell>
New-Item -Path "C:\" -Name "OutputDir" -ItemType "directory"
New-Item -Path "C:\OutputDir" -Name "test.txt" -ItemType "file" -Value "This is a text string."
</powershell>

EOF
}
