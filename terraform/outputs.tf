output "public_ip" {
  value = aws_instance.freenow_ec2.public_ip
}

output "RDS_HOSTNAME" {
  value = aws_db_instance.freenow_db.endpoint
}

output "S3_BUCKET" {
  value = aws_s3_bucket.freenow_bucket.bucket
}

