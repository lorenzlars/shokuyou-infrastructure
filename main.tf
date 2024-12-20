terraform {
  required_providers {
    heroku = {
      source  = "heroku/heroku"
      version = "~> 5.0"
    }
  }
}

provider "heroku" {
  api_key = var.heroku_api_key
}

variable "heroku_api_key" {}

resource "heroku_app" "shokuyou-backend" {
  acm              = true
  buildpacks       = ["heroku/nodejs"]
  config_vars      = {}
  git_url          = "https://git.heroku.com/shokuyou-backend.git"
  heroku_hostname  = "shokuyou-backend-7385047ef6ab.herokuapp.com"
  id               = "9d0c532c-806a-45b5-8b46-5e0d922c7109"
  internal_routing = false
  name             = "shokuyou-backend"
  region           = "eu"
  stack            = "heroku-24"
  uuid             = "9d0c532c-806a-45b5-8b46-5e0d922c7109"
  web_url          = "https://shokuyou-backend-7385047ef6ab.herokuapp.com/"
}

resource "heroku_app" "shokuyou-frontend" {
  acm              = true
  buildpacks       = ["heroku/nodejs"]
  config_vars      = {}
  git_url          = "https://git.heroku.com/shokuyou-frontend.git"
  heroku_hostname  = "shokuyou-frontend-7c9ac42bdc24.herokuapp.com"
  id               = "2bc6b584-443a-4358-aff2-9663b7148cf8"
  internal_routing = false
  name             = "shokuyou-frontend"
  region           = "eu"
  stack            = "heroku-24"
  uuid             = "2bc6b584-443a-4358-aff2-9663b7148cf8"
  web_url          = "https://shokuyou-frontend-7c9ac42bdc24.herokuapp.com/"
}
