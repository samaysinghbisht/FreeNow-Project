resource "aws_s3_bucket" "freenow_bucket" {
  depends_on = [aws_db_instance.freenow_db]
  bucket     = var.bucket_name
  tags = {
    Name = "freenow-s3"
  }
}