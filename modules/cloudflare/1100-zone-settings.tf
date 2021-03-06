resource "cloudflare_zone_settings_override" "cloudflare" {
  zone_id = var.cloudflare_zone_id
  settings {
    brotli                   = "off"
    challenge_ttl            = 1800
    security_level           = "medium"
    automatic_https_rewrites = "on"
    minify {
      css  = "on"
      js   = "on"
      html = "on"
    }
    security_header {
      enabled = true
    }
  }
}