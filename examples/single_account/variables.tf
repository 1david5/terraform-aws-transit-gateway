variable "region_a" {
  type        = string
  description = "Region A code name"
  default     = "us-east-1"
}

variable "region_b" {
  type        = string
  description = "Region B code name"
  default     = "us-east-2"
}

variable "vpc_a_cidr_block" {
  type        = string
  description = "Cidr block of the VPC_A"
}

variable "vpc_aa_cidr_block" {
  type        = string
  description = "Cidr block of the VPC_AA"
}

variable "vpc_b_cidr_block" {
  type        = string
  description = "Cidr block of the VPC_B"
}
