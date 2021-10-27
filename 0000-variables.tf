// Database
variable "db_username" {
  description = "Psider database username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Psider database password"
  type        = string
  sensitive   = true
}


// Cloudflare
variable "cloudflare_account_id" {
  description = "Cloudflare account ID"
  type        = string
  sensitive   = true
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}