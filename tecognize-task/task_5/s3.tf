### aws_s3_bucket

resource "aws_s3_bucket" "s3-bucket" {
  bucket = local.s3_bucket_name
  #  acl           = "private"
  force_destroy = true

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_elb_service_account.root.arn}"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}"
    }
  ]
}
    POLICY

  tags = local.common_tag

}


### aws_s3_bucket_object

resource "aws_s3_object" "s3-bucket-object-1" {
  bucket = aws_s3_bucket.s3-bucket.bucket
  key    = "/website/index-1.html"
  source = "./website/index-1.html"

  tags = local.common_tag

}

resource "aws_s3_object" "s3-bucket-object-2" {
  bucket = aws_s3_bucket.s3-bucket.bucket
  key    = "/website/index-2.html"
  source = "./website/index-2.html"

  tags = local.common_tag

}


### aws_iam_role

resource "aws_iam_role" "allow-s3" {
  name = "allow-s3"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = local.common_tag
}


### aws_iam_role_policy

resource "aws_iam_role_policy" "allow-s3-all" {
  name = "allow-s3-all"
  role = aws_iam_role.allow-s3.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
                "arn:aws:s3:::${local.s3_bucket_name}",
                "arn:aws:s3:::${local.s3_bucket_name}/*"
            ]
    }
  ]
}
EOF

}


### aws_iam_instance profile

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "iam-instance-profile"
  role = aws_iam_role.allow-s3.name

  tags = local.common_tag
}


### aws_s3_bucket_acl

resource "aws_s3_bucket_acl" "s3-bucket-acl" {
  bucket = aws_s3_bucket.s3-bucket.id
  acl    = "private"
}
