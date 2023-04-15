data "aws_ami" "ami-linux" {
  owners      = ["amazon"]
  most_recent = true
  

  filter {
    name   = "name"
    values = ["al2023-ami*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  
  ami           = data.aws_ami.ami-linux.id
  instance_type = "t2.micro"
  key_name = "ansible-key"
  vpc_security_group_ids = [var.web-sg]
  tags = {
    Name = "Jenkins-Ansible-Master"
  }
  iam_instance_profile = "ansible-dynamic-inventory-plugin"
  
  provisioner "file" {
    source      = "./local/aws_ec2.yaml"
    destination = "/tmp/aws_ec2.yaml"
    connection {
     type        = "ssh"
     user        = "ec2-user"
     private_key = file("C:/Users/15678/Downloads/key.pem")
     host        = aws_instance.web.public_ip
     timeout     = "2m"
         }
    }
  
 
  provisioner "file" {
    source      = "./local/ec2.pem"
    destination = "/tmp/ec2.pem"
    connection {
     type        = "ssh"
     user        = "ec2-user"
     private_key = file("C:/Users/15678/Downloads/key.pem")
     host        = aws_instance.web.public_ip
     timeout     = "2m"
         }
  }
   
 provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo dnf install java-11-amazon-corretto -y",
      "sudo yum install wget -y",
      "sudo yum installl git -y",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key",
      "sudo yum install -y jenkins",
      "sudo systemctl start jenkins",
      "sudo systemctl enable jenkins",
      "sudo yum install -y python3-pip python3-devel gcc",
      "sudo pip3 install ansible",
      "ansible-galaxy collection install amazon.aws",
      "sudo pip3 install boto3",
      
      
    ]
  }
  connection {
  type        = "ssh"
  user        = "ec2-user"
  private_key = file("C:/Users/15678/Downloads/key.pem")
  host        = aws_instance.web.public_ip
  timeout     = "2m"
}


}

resource "aws_instance" "application-host" {
  ami           = data.aws_ami.ami-linux.id
  instance_type = "t2.micro"
  key_name = "ansible-key"
  vpc_security_group_ids =   [var.web-sg] 
  tags = {
    Name = "Application-Host"
  } 
  iam_instance_profile = "ansible-dynamic-inventory-plugin"
}
