resource "google_compute_firewall" "drupalfirewall"{
	name = "drupalfirewall"
	network = "secure-net"
	target_tags = ["drupal"]
	source_ranges = ["0.0.0.0/0"]

	allow {
		protocol = "icmp"
	}
	allow {
		protocol = "tcp"
		ports = ["80", "443"]
	}
}
