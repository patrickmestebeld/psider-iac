variable "prefix" {
  description = "prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "VPC subnet ID"
  type        = string
}

variable "db_host" {
  description = "database host"
  type        = string
}

variable "db_port" {
  description = "database port"
  type        = string
}

variable "db_name" {
  description = "database name"
  type        = string
}

variable "db_username" {
  description = "database username"
  type        = string
}

variable "db_password" {
  description = "database password"
  type        = string
} 
