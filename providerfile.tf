provider "google" {
  credentials = "${file("./service_account_key.json")}"
  project = "idmobile-interview"
  region = "europe-west2"
}
