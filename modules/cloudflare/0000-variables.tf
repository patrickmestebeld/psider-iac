variable "prefix" {
  description = "prefix"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare's zone_id"
  type        = string
  default     = "86b706b64f7f22b0ae2a0f99b9f9e130"
}

variable "domain_name" {
  description = "your domain like: example.com"
  type        = string
}

variable "public_ip" {
  description = "public IP"
  type        = string
}