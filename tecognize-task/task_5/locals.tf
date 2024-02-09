locals {
  common_tag = {
    company = var.company
    project = "${var.company}-${var.project}"
  }

  s3_bucket_name = "terrafrom-${random_integer.rand.result}"


}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}