terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "6.55.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket =  "s3-backend-bucket-terraformtfstate"
    region = "ap-south-1"
    key = "backend/terraform.tfstate"
    
  }
}

provider "aws" {
    region = "ap-south-1"
}



resource "aws_security_group" "mysg" {
    vpc_id = "vpc-03987eef9d69ca4e8"
    ingress {
        from_port =  22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    

    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks =["0.0.0.0/0"]
    }

}

resource "aws_eip" "myeip" {
    instance = aws_instance.server-1.id 
  
}

resource "aws_instance" "server-1" {
    instance_type = "c7i-flex.large"
    availability_zone = "ap-south-1a"
    ami = "ami-0b1ed96948adabcd9"
    key_name = "jenkins"
    vpc_security_group_ids = [ aws_security_group.mysg.id ]
    
    provisioner "local-exec" {
        command = <<EOT
        sudo sleep 30
        sudo ssh-keygen -R ${self.public_ip}
        sudo ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i ${self.public_ip}, playbook.yaml -u ec2-user --private-key /home/ec2-user/jenkins.pem
        EOT
      
    }
}