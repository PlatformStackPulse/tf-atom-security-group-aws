variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "vpc_id must not be empty."
  }
}

variable "description" {
  description = "Description of the security group"
  type        = string
  default     = null
}
