variable "team_name" {
  description = "Required variable used for tagging, naming and isolating teams"
  #tflint-advised-fix
  type = string
}

variable "environment" {
  description = "Required variable for isolating environments"
  #tflint-advised-fix
  type = string
}
