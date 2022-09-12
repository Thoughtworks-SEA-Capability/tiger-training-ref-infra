variable "team_name" {
  description = "Required variable used for tagging, naming and isolating teams"
  #tflint-fix
  type = string
}

variable "environment" {
  description = "Required variable for isolating environments"
  #tflint-fix
  type = string
}
