resource "cloudflare_record" "www" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  value   = var.public_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "cms" {
  zone_id = var.cloudflare_zone_id
  name    = "cms"
  value   = var.public_ip
  type    = "A"
  proxied = true
}