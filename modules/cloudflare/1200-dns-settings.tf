locals {
  subdomains = ["www", "cms", "demo", "preview"]
}

resource "cloudflare_record" "www" {
  for_each = toset(local.subdomains)

  zone_id = var.cloudflare_zone_id
  name    = each.value
  value   = var.public_ip
  type    = "A"
  proxied = true
}