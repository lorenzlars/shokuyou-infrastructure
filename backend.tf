resource "heroku_app" "shokuyou_backend" {
  acm = true
  config_vars = {
    SECRET = local.secrets.backend_secret
  }
  name   = "shokuyou-backend"
  region = "eu"
  stack  = "container"
}

# Configure addons

resource "heroku_addon" "database" {
  app_id = heroku_app.shokuyou_backend.id
  plan   = "heroku-postgresql:essential-0"
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
