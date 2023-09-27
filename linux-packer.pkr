#This required_plugins block is used to extend packer functionality, the amazon plugin allows packer to do more things 
packer {
    required_plugins {
        amazon = {
            version = ">= 1.2.6"
            source = "github.com/hashicorp/amazon"
        }
    }
}
packer {
  required_plugins {
    ansible = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

#Initializing region variable
variable "region" {
    type = string
    default = "us-east-2"
}

#Basically going to use this to give templates a unique name
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }


 #Creating base image for template, in AWS we are going to search for an AMI that meets our filtered requirements
 source "amazon-ebs" "packer-ansible-Z" {
    ami_name = "PackerAnsible-${local.timestamp}"
    communicator = "ssh"
    instance_type = "t2.micro"
    region = "${var.region}"
    source_ami_filter {
        filters = {
            name = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
            root-device-type = "ebs"
            virtualization-type = "hvm"
        }
        most_recent = true
        owners = ["099720109477"]
    }
    ssh_username = "ubuntu"
 }

 build {
    name = "CICDplsWork"
    sources = ["amazon-ebs.packer-ansible-Z"]

    provisioner "ansible" {
        playbook_file = "./playbook.yml"
    }
 }
