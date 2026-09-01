resource "aws_instance" "app" {
  ami           = "ami-0f48d8eda3141f50a"
  instance_type = var.ec2_instance_type

  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
              #!/bin/bash

              dnf update -y
              dnf install -y docker awscli amazon-ssm-agent

              systemctl enable docker
              systemctl start docker

              systemctl enable amazon-ssm-agent
              systemctl start amazon-ssm-agent

              aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 777040315554.dkr.ecr.ap-south-1.amazonaws.com

              docker pull 777040315554.dkr.ecr.ap-south-1.amazonaws.com/8byte-devops-app:1.0

              docker run -d --name 8byte-devops-container -p 5000:5000 777040315554.dkr.ecr.ap-south-1.amazonaws.com/8byte-devops-app:1.0
              EOF

  tags = {
    Name = "8byte-devops-app"
  }
}