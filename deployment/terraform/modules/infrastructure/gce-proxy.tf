
resource "google_compute_instance" "mde_proxy" {
  name         = "mde-proxy"
  project      = var.mde_project_id
  machine_type = var.mde_size_details[var.mde_size].mde_proxy_gce_machine_type
  zone         = var.mde_zone
  tags         = ["iap-ssh"]
  labels       = var.mde_deployment_labels
  allow_stopping_for_update = true
  network_interface {
    network    = var.mde_network
    subnetwork = var.mde_subnet_self_link
  }
  service_account {
    email  = google_service_account.mde_proxy_sa.email
    scopes = ["cloud-platform"]
  }
  boot_disk {
    auto_delete = true
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 10
    }
  }
  depends_on = [
    google_container_cluster.mde_gke
  ]
}
