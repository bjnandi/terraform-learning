variable "ami" {
  default = "ami-062df10d14676e201"
}

variable "aws_instance" {
  default = "t2.micro"
}
variable "subnet_id" {
  default = "subnet-016875cc812b02b0b"
}

variable "filename" {
  default     = "pets.text"
  type        = string
  description = "File name of local file"
}
variable "content" {
  type = map(any)
  default = {
    "statement1" = "we love Bangladesh!"
    "statement2" = "we love Programming"
  }

}
variable "prefix" {
  default     = ["Mr", "Mrs", "Sir"]
  type        = list(any)
  description = "prefix name of local file"
}
variable "separator" {
  default = "."
}
variable "length" {
  default = "1"
}
