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
	metadata{
		sshKeys = "mzgadd:${file("/home/mzgadd/.ssh/id_rsa.pub")}"
	}
	connection = {
		type = "ssh"
		user = "mzgadd"
		private_key = "${file("/home/mzgadd/.ssh/id_rsa")}"
	}
}
resource "null_resource" "get_drupal"{
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
