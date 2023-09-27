#This required_plugins block is used to extend packer functionality, the amazon plugin allows packer to do more things 
packer {
    required_plugins {
        amazon = {
            version = ">= 0.0.1"
            source = "github.com/hashicorp/amazon"
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
 source "amazon-ebs" "packer-windows-Z" {
    ami_name = "HopefullythisCICDpipelineWorks-${local.timestamp}"
    communicator = "winrm"
    instance_type = "t2.micro"
    region = "${var.region}"
    source_ami_filter {
        filters = {
            name = "Windows_Server-2019-English-Full-Base*"
            root-device-type = "ebs"
            virtualization-type = "hvm"
        }
        most_recent = true
        owners = ["amazon"]
    }
    user_data_file = "./bootstrap_win.txt"
    winrm_password = "SuperS3cr3t!!!!"
    winrm_username = "Administrator"
 }

 build {
    name = "CICDplsWork"
    sources = ["amazon-ebs.packer-windows-Z"]

    provisioner "powershell" {
        script = "./winrm_enable.ps1"
    }
 }
