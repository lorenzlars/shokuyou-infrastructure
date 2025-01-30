resource "vercel_project" "shokuyou_frontend" {
  name = "shokuyou"

  build_command    = "pnpm run build"
  output_directory = "dist"
}

resource "vercel_project_domain" "shokuyou_frontend" {
  project_id = vercel_project.shokuyou_frontend.id
  domain     = local.frontend_hostname
}

resource "cloudflare_record" "shokuyou_frontend" {
  zone_id = local.secrets.cloudflare_zone_id
  name    = "api.shokuyou"
  type    = "CNAME"
  content = "cname.vercel-dns.com"
}
