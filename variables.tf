variable "name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "repository_policy" {
  description = "Optional JSON policy document to attach to the ECR repository. Only the Statement array will be merged."
  type        = string
  default     = null
}
