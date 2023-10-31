resource "aws_route53_zone" "private_zone" {
  name = "mysimplewebsite.playground.free-now.com"
  vpc {
    vpc_id = aws_vpc.freenow_vpc.id
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "www.mysimplewebsite.playground.free-now.com"
  type    = "A"
  ttl     = "300"
  records = [aws_lb.freenow_alb.dns_name] 
}
