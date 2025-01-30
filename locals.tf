locals {
  backend_hostname  = "api.shokuyou.larslorenz.dev"
  frontend_hostname = "shokuyou.larslorenz.dev"

  labels = {
    heroku_api_key       = "heroku_api_key"
    vercel_api_token     = "vercel_api_token"
    cloudflare_api_token = "cloudflare_api_token"
    backend_secret       = "backend_secret"
    cloudflare_zone_id   = "cloudflare_zone_id"
  }

  secrets = {
    for key, label in local.labels :
    key => [
      for obj in data.onepassword_item.secrets.section[0].field : obj
      if obj.label == label
    ][
    0
    ].value
  }
}

