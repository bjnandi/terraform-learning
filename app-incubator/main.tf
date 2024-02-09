provider "aws" {
  profile = "default"
  region  = "ap-south-1"
}
resource "aws_instance" "test" {
  ami           = "ami-062df10d14676e201"
  instance_type = "t2.micro"
  subnet_id     = "subnet-016875cc812b02b0b"
}

resource "aws_s3_bucket" "test" {
  bucket = "testbjjgfhgfhf"
  acl    = "private"
}
resource "aws_iam_user" "user" {
  name = "biswajit"

}
