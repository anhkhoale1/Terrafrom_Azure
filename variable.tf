variable "rgs" {
  type = map(object({
    name     = string
    location = string
  }))

  default = {
    "first" = {
      location = "West Europe"
      name     = "aklwesteu"
    }
    "second" = {
      location = "West US"
      name     = "aklwestus"
    }
    "third" = {
      location = "France Central"
      name     = "aklfc"
    }
  }
}