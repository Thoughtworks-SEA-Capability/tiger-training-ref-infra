variable "team_name" {
  description = "Required variable used for tagging, naming and isolating teams"
  type = string
}

variable "environment" {
  description = "Required variable for isolating environments"
  type = string
}
