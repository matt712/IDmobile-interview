resource "google_compute_address" "static" {
	name="ipv4-address"
}
resource "google_compute_instance" "drupalrunner"{
	name = "drupalrunner"
	machine_type = "n1-standard-1"
	zone = "europe-west2-c"
	tags = ["drupal"]
	boot_disk {
		initialize_params {
			image = "centos-7-v20190423"
		}
	}
	network_interface {
		network = "secure-net"
		access_config {
			nat_ip = "${google_compute_address.static.address}"
		}
	}
	provisioner "file" {
		source = "script.sh"
		destination = "/tmp/script.sh"
	}
	provisioner "file" {
		source = "script2.sh"
		destination = "/tmp/script2.sh"
	}
	provisioner "file" {
		source = "script3.sh"
		destination = "/tmp/script3.sh"
	}
	provisioner "file" {
		source = "script4.sh"
		destination = "/tmp/script4.sh"
	}
	metadata{
		sshKeys = "mzgadd:${file("/home/mzgadd/.ssh/id_rsa.pub")}"
	}
	connection = {
		type = "ssh"
		user = "mzgadd"
		private_key = "${file("/home/mzgadd/.ssh/id_rsa")}"
	}
}
resource "null_resource" "get_apache_server"{
	depends_on = ["google_compute_instance.drupalrunner"]
	connection = {
		host = "${google_compute_address.static.address}"
		type = "ssh"
		user = "mzgadd"
		private_key = "${file("/home/mzgadd/.ssh/id_rsa")}"
	}
	provisioner "remote-exec" {
		inline = [
				"sudo yum install dos2unix -y",
				"dos2unix /tmp/script.sh",
				"chmod +x /tmp/script.sh",
				"sudo sh /tmp/script.sh",
			]
	}	
}
resource "null_resource" "get_php"{
	depends_on = ["null_resource.get_apache_server"]
	connection = {
                host = "${google_compute_address.static.address}"
                type = "ssh"
                user = "mzgadd"
                private_key = "${file("/home/mzgadd/.ssh/id_rsa")}"
        }
	provisioner "remote-exec"{
		inline = [
			"dos2unix /tmp/script2.sh",
			"chmod +x /tmp/script2.sh",
			"sudo sh /tmp/script2.sh",
			]
	}
}
resource "null_resource" "get_mariadb"{
	depends_on = ["null_resource.get_php"]
	connection = {
                host = "${google_compute_address.static.address}"
                type = "ssh"
                user = "mzgadd"
                private_key = "${file("/home/mzgadd/.ssh/id_rsa")}"
        }
	provisioner "remote-exec"{
		inline = [
			"dos2unix /tmp/script3.sh",
			"chmod +x /tmp/script3.sh",
			"sudo sh /tmp/script3.sh",
			]
	}
}
resource "null_resource" "setup_drupal"{
	depends_on = ["null_resource.get_mariadb"]
	connection = {
                host = "${google_compute_address.static.address}"
                type = "ssh"
                user = "mzgadd"
                private_key = "${file("/home/mzgadd/.ssh/id_rsa")}"
        }
        provisioner "remote-exec"{
                inline = [
                        "dos2unix /tmp/script4.sh",
                        "chmod +x /tmp/script4.sh",
                        "sudo sh /tmp/script4.sh",
                        ]
        }
}
