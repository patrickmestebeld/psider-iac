variable "prefix" {
  description = "prefix"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare's zone_id"
  type        = string
  default     = "4e055c912c34ef636c46ce5e994f4499"
}

variable "domain_name" {
  description = "your domain like: example.com"
  type        = string
}

variable "public_ip" {
  description = "public IP"
  type        = string
}