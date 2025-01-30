resource "heroku_app" "shokuyou_backend" {
  acm = true
  buildpacks = ["heroku/nodejs"]
  config_vars = {
    SECRET                = local.secrets.backend_secret
    CLOUDINARY_CLOUD_NAME = var.cloudinary_cloud_name
  }
  name   = "shokuyou-backend"
  region = "eu"
  stack  = "heroku-24"
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

# Configure domain

resource "heroku_domain" "shokuyou_backend" {
  app_id   = heroku_app.shokuyou_backend.id
  hostname = local.backend_hostname
}

resource "cloudflare_record" "shokuyou_backend" {
  zone_id = local.secrets.cloudflare_zone_id
  name    = "api.shokuyou"
  type    = "CNAME"
  content = heroku_domain.shokuyou_backend.cname
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
