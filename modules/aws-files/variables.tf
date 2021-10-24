variable "prefix" {
  description = "prefix"
  type = string
}

variable "sources" {
  description = "sources to upload"
  type = map(string)
}