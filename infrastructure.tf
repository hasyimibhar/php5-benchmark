provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

resource "aws_security_group" "webserver" {
    name = "webserver"
    description = "Web server security group"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "webserver" {
    connection {
        user = "ubuntu"
        key_file = "${var.aws_key_path}"
    }

    instance_type = "${var.aws_instance_type}"
    ami = "${var.aws_ami}"
    key_name = "${var.aws_key_name}"
    security_groups = ["${aws_security_group.webserver.name}"]

    provisioner "local-exec" {
        command = "mkdir -p .tmp && rsync -az --exclude=.git puppet/ .tmp/puppet"
    }

    provisioner "file" {
        source = ".tmp/puppet"
        destination = "/home/ubuntu"
    }

    provisioner "remote-exec" {
        script = "provision.sh"
    }
}
