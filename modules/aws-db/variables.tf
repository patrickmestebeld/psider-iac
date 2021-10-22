variable "prefix" {
  description = "prefix"
  type = string
}

variable "vpc_id" {
  description = ""
  type = string
}

variable "security_groups" {
  description = ""
  type = list(string)
}

variable "subnet_ids" {
  description = ""
  type = list(string)
}

variable "db_username" {
  description = "Database username"
  type = string
  sensitive = true
}

variable "db_password" {
  description = "Database password"
  type = string
  sensitive = true
}

variable "db_port" {
  description = "Psider database port"
  type = number
}