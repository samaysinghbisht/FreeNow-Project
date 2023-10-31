resource "aws_instance" "freenow_ec2" {
  depends_on      = [aws_s3_bucket.freenow_bucket]
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = "private-key"
  subnet_id       = aws_subnet.freenow_subnet[0].id
  security_groups = [aws_security_group.freenow_ec2_sg.id]

  iam_instance_profile = aws_iam_instance_profile.freenow_ec2_instance_profile.name
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("private-key.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install docker -y",
      "sudo systemctl start docker.service",
      "export RDS_HOSTNAME='${aws_db_instance.freenow_db.address}'",
      "export BUCKET_NAME='${aws_s3_bucket.freenow_bucket.bucket}'",
      "export DATABASE_NAME='${aws_db_instance.freenow_db.db_name}'",
      "export RDS_USERNAME='${aws_db_instance.freenow_db.username}'",
      "sudo docker pull samay1993/freenow:latest",
      "sudo docker run -d -p 80:80 -e RDS_HOSTNAME=$RDS_HOSTNAME -e RDS_USERNAME=$RDS_USERNAME -e TABLE_NAME=freenow -e RDS_PASSWORD=dbpassword -e DATABASE_NAME=$DATABASE_NAME -e BUCKET_NAME=$BUCKET_NAME samay1993/freenow:latest"
    ]
  }
  tags = {
    Name = "freenow-ec2"
  }
}
