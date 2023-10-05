terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.10"
    }
  }
  backend "gcs" {
    bucket = "my-bucket-2023-10-05"
  }
  required_version = ">= 1.0"
}

provider "google" {
    project = "my-project-372823"
}

resource "google_project_service" "ressource_manager" {
    service = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "ressource_usage" {
    service = "serviceusage.googleapis.com"
    depends_on = [ google_project_service.ressource_manager ]
}

resource "google_storage_bucket" "bucket" {
    name          = "my-bucket-2023-10-05"
    location      = "us"
}

resource "google_project_service" "artifact" {
    service = "artifactregistry.googleapis.com"
    depends_on = [ google_project_service.ressource_manager ]
}

resource "google_artifact_registry_repository" "artifact-repo" {
  location      = "us-central1"
  repository_id = "website-tools"
  format        = "DOCKER"
  depends_on = [ google_project_service.artifact ]
}

resource "google_sql_database_instance" "wordpress" {
  name             = "main-instance"
  database_version = "MYSQL_8_0"
  region           = "us-central1"
  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_user" "wordpress" {
   name     = "wordpress"
   instance = "main-instance"
   password = "ilovedevops"
}
