terraform {
  required_providers {
    # https://registry.terraform.io/providers/1Password/onepassword/latest/docs
    onepassword = {
      source  = "1Password/onepassword"
      version = "~> 2.0.0"
    }
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
    # https://registry.terraform.io/providers/vercel/vercel/latest/docs
    vercel = {
      source  = "vercel/vercel"
      version = "~> 2.0"
    }
  }
}

provider "onepassword" {
  account = var.onepassword_account_id
}

provider "heroku" {
  api_key = local.secrets.heroku_api_key
}

provider "vercel" {
  api_token = local.secrets.vercel_api_token
}

provider "cloudflare" {
  api_token = local.secrets.cloudflare_api_token
}

