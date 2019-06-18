variable "cluster-name" {
  default     = "gc-cluster"
  description = "The name of your EKS Cluster"
}

variable "aws-region" {
  default     = "us-east-1"
  description = "The AWS Region to deploy EKS"
}

variable "k8s-version" {
  default     = "1.11"
  description = "Required K8s version"
}

variable "vpc-subnet-cidr" {
  default     = "10.0.0.0/16"
  description = "The VPC Subnet CIDR"
}

variable "node-instance-type" {
  default     = "t2.micro"
  description = "Worker Node EC2 instance type"
}

variable "desired-capacity" {
  default     = 1
  description = "Autoscaling Desired node capacity"
}

variable "max-size" {
  default     = 2
  description = "Autoscaling maximum node capacity"
}

variable "min-size" {
  default     = 1
  description = "Autoscaling Minimum node capacity"
}

variable "key_name" {
  default     = "gc-key.pem"
  description = "Autoscaling Minimum node capacity"
}