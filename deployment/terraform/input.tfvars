# input.tfvars
# replace the <PROJECT-ID> with your actual project ID
# replace correct mde_artifact_registry_sa_path

mde_project_id          = "seidor-mde"
mde_bigquery_project_id = "seidor-mde"

mde_size = "Pilot" # Pilot, Small, Medium or Large. Check the documentation for details

mde_tf_sa                     = "mde-tf@seidor-mde.iam.gserviceaccount.com"
mde_dataflow_sa               = "mde-df-worker@seidor-mde.iam.gserviceaccount.com"
mde_artifact_registry_sa_path = "~/mde-projects/seidor-mde/mde-imgs-service-account-key.json"

mde_region            = "europe-west1"
mde_zone              = "europe-west1-d"
mde_bigquery_location = "EU"
mde_gke_location      = "europe-west1"

mde_ui_enabled = false
mde_ui_ext_http_lb = {
  enabled = false
  domain = ""
}