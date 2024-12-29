locals {
  backend_hostname  = "api.shokuyou.larslorenz.dev"
  frontend_hostname = "shokuyou.larslorenz.dev"
}

terraform {
  required_providers {
    # https://registry.terraform.io/providers/heroku/heroku/latest/docs
    heroku = {
      source  = "heroku/heroku"
      version = "~> 5.0"
    }
    # https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

variable "heroku_api_key" {
  description = "Heroku API Key"
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone Id for larslorenz.dev"
}

variable "cloudflare_api_token" {
  description = "Cloudflare Account Api Token"
}

variable "backend_secret" {
  description = "Backend JWT secret"
}

variable "cloudinary_cloud_name" {
  description = "Cloudinary Cloud Name"
}

provider "heroku" {
  api_key = var.heroku_api_key
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Configure apps

resource "heroku_app" "shokuyou_backend" {
  acm        = true
  buildpacks = ["heroku/nodejs"]
  config_vars = {
    SECRET                = var.backend_secret
    CLOUDINARY_CLOUD_NAME = var.cloudinary_cloud_name
  }
  name   = "shokuyou-backend"
  region = "eu"
  stack  = "heroku-24"
}

resource "heroku_app" "shokuyou_frontend" {
  acm        = true
  buildpacks = ["heroku/nodejs", "heroku/php"]
  config_vars = {
    VITE_API_URL = "https://${local.backend_hostname}/"
  }
  name   = "shokuyou-frontend"
  region = "eu"
  stack  = "heroku-24"
}

resource "heroku_app_feature" "shokuyou_frontend-routing" {
  app_id = heroku_app.shokuyou_frontend.id
  name   = "http-routing-2-dot-0"
}

# Configure addons

resource "heroku_addon" "database" {
  app_id = heroku_app.shokuyou_backend.id
  plan   = "heroku-postgresql:essential-0"
}

resource "heroku_addon" "cloudinary" {
  app_id = heroku_app.shokuyou_backend.id
  plan   = "cloudinary"
}

# Configure domains

resource "heroku_domain" "shokuyou_backend" {
  app_id   = heroku_app.shokuyou_backend.id
  hostname = local.backend_hostname
}

resource "heroku_domain" "shokuyou_frontend" {
  app_id   = heroku_app.shokuyou_frontend.id
  hostname = local.frontend_hostname
}

# Configure pipeline

resource "heroku_pipeline" "shokuyou" {
  name = "shokuyou"
}

resource "heroku_pipeline_coupling" "production_backend" {
  app_id   = heroku_app.shokuyou_backend.id
  pipeline = heroku_pipeline.shokuyou.id
  stage    = "production"
}

resource "heroku_pipeline_coupling" "production_frontend" {
  app_id   = heroku_app.shokuyou_frontend.id
  pipeline = heroku_pipeline.shokuyou.id
  stage    = "production"
}

# Setup Cloudflare records

resource "cloudflare_record" "shokuyou_backend" {
  zone_id = var.cloudflare_zone_id
  name    = "api.shokuyou"
  type    = "CNAME"
  content = heroku_domain.shokuyou_backend.cname
}

resource "cloudflare_record" "shokuyou_frontend" {
  zone_id = var.cloudflare_zone_id
  name    = "shokuyou"
  type    = "CNAME"
  content = heroku_domain.shokuyou_frontend.cname
}
