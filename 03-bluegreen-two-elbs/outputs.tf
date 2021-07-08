output "prod_lb_dns_name" {
  value = aws_lb.production.dns_name
}

output "stag_lb_dns_name" {
  value = aws_lb.staging.dns_name
}
