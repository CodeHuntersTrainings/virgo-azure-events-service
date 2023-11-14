variable "public-subnet" {
  description   = "Public subnet CIDR"
  type          = string
  default       = "10.0.1.0/24"
}

variable "private-subnet" {
  description   = "Private subnet CIDR"
  type          = string
  default       = "10.0.100.0/24"
}