variable "region" {
  default = "us-east-1"

}

variable "ami" {
  type = map(string)
  default = {
    master  = "ami-0e001c9271cf7f3b9"
    workers = "ami-0e001c9271cf7f3b9"
  }

}

variable "instance_type" {
  type = map(string)
  default = {
    master  = "t2.medium"
    workers = "t2.micro"
  }

}

variable "workers_nodes_count" {
  type    = number
  default = 2
}