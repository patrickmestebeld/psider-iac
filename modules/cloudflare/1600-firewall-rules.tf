resource "cloudflare_filter" "non_dutch_traffic_filter" {
  zone_id     = var.cloudflare_zone_id
  description = "Filter traffic not originating from the Netherlands."
  expression  = "(ip.geoip.country ne \"NL\")"
}

resource "cloudflare_firewall_rule" "non_dutch_traffic_fw_rule" {
  zone_id     = var.cloudflare_zone_id
  description = "Block traffic not originating from the Netherlands."
  filter_id   = cloudflare_filter.non_dutch_traffic_filter.id
  action      = "block"
}