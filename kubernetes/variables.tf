variable "namespace_name" {
  default = "gc-namespace"
  type    = "string"
}

variable "nginx_pod_name" {
  default = "gc-service"
  type    = "string"
}

variable "nginx_pod_image" {
  default = "nginx:latest"
  type    = "string"
}
