resource "aws_instance" "sandipWeb" {
  ami                    = data.aws_ami.amazon.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ssh.id, aws_security_group.http.id]
  key_name               = aws_key_pair.ssh_key.key_name
  tags = {
    "Name" = "sandWeb"
  }
connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file("~/.ssh/id_rsa")}"
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ 
      "sudo yum -y install httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
    ] 
  }
  
  provisioner "file" {
    source = "./index.html"
    destination = "/var/www/html/index.html"
  }
}



resource "aws_security_group" "ssh" {
  name     = "ssh_SG"
  vpc_id   = data.aws_vpc.vpc.id
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

data "aws_vpc" "vpc" {
  default = true
}

resource "aws_security_group" "http" {
  name     = "http_SG"
  vpc_id   = data.aws_vpc.vpc.id
  ingress {
    description = "http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_http"
  }

}

data "aws_ami" "amazon" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}

resource "aws_key_pair" "ssh_key" {
  key_name = "devopskey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCy8GtPgNFCb780i9eO/+1ysn0dmc9QxBGoCBKrMEM8MImUbPm6BG2IvIrKQmcR5f0hXVi99eR5pnmE9qcjVS2EjJTGZLClb+V7hk+PgbcVoK0rYDwRkQtCaYZtp0Qhzpbb/26eihKCJxE9GgbKIhZ4mjQHDlQI3ch/GKfjX1kOI6w7irBWV3bw6X8ocytYrX7Hzqsu43Xi6QUs7Sn/sSrQQWZKrJLLjimQ1H7C2YCg5rFae9L9sXyc2HY9G88Pl8TN32cVfW2nUHY/xW6XgZ8HHURBYiiMeAd7EvfuLensEN1qIo+yHYb/rYWOeBDFBP8dthI49pAcFn8kDc1LVTGqPMM97j0tyzaNXgTNZTrrpXVMkgvW8Q0ARaxZegk/AioR1QKC4vN+KQOel2rKQv+sOJHSft7Hh2bTA9HT5TkzxqTCFazgMIGtO2ipgUSri5X8xmm90jZ7CcTcLhLFmJ88yKUvdY77N2zX77H6sOOahFPtEVAmKnsACIAhoFzrCt0= sandi@LAPTOP-JA5VNQ5D"
}
