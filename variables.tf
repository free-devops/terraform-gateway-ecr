variable "protocol" {
  description = "protocol_type"
  type = string
  validation {
    condition = can(regex("HTTP|WEBSOCKET", var.protocol))
    error_message = "Protocol type for v2 can only be HTTP or WEBSOCKET."
  }
}

variable "name" {
  type = string
}

variable "scan" {
  description = "Scan images on push"
  type = bool
}

variable "tags" {
  description = "Repository tags"
  type = map(string)
}

variable "env" {
  description = "Environment"
  type = string

  validation {
    condition = can(regex("dev|stage|prod", var.env))
    error_message = "Available => dev|stage|prod."
  }
}

variable "respositores" {
  description = "List of repository name"
  type = list(string)
}

variable "fn_name" {
  description = "Lambda fn name that will perform auth actions"
  type = string
}

variable "lambda_zip" {
  description = "Lambda zip to deploy"
  type = string
}

variable "lambda_source" {
  description = "Lambda zip source"
  type = string

  validation {
    condition = can(regex("local|s3", var.lambda_source))
    error_message =  "Currently only local or S3 is possible."
  }
}

variable "lambda_s3" {
  description = "If lambda_source is set to s3, s3 bucket name must be provided"
  type = string
  default = ""

  #validation {
  #  condition = var.lambda_source == "s3" && var.lambda_s3 != ""
  #  error_message = "If lambda_source is set to s3, lambda_s3 must not be an empty string."
  #}
}

variable "handler" {
  description = "Handler file of lambda"
  type = string
}

variable "runtime" {
  description = "Lambda runtime"
  type = string
}

variable "gw_path" {
  description = "Gateway path"
  type = string
  default = "/"
}
