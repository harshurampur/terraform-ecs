variable "workspace" {
  description = "The name of the workspace"
}

variable "cluster" {
  description = "The name of the cluster"
}

variable "owner" {
  description = "mailing list that represents the owner of the service"
}

variable "ssm_decrypt_key" {
  description = "Alias for the ssm decrypt key to access secure ssm parameters"
  default     = "aws/ssm"
}

variable "account_id" {
  description = "The account id for specifying arns"
}

variable "aws_region" {
  description = "The aws region for the service"
}

variable "ec2_security_group" {
  description = "The security group applied to the ecs compute nodes"
}

variable "task_role_name" {
  description = "The name of the role"
}
