variable "namespace_name" {
  default = "gamersclube"
  type    = "string"
}

variable "nginx_pod_name" {
  default = "gcService"
  type    = "string"
}

variable "nginx_pod_image" {
  default = "nginx:latest"
  type    = "string"
}
