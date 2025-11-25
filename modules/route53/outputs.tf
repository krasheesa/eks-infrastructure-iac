output "zone_id" {
  description = "Route53 zone ID"
  value       = var.create_zone ? aws_route53_zone.main[0].zone_id : data.aws_route53_zone.existing[0].zone_id
}

output "zone_arn" {
  description = "Route53 zone ARN"
  value       = var.create_zone ? aws_route53_zone.main[0].arn : data.aws_route53_zone.existing[0].arn
}

output "zone_name_servers" {
  description = "Name servers for the Route53 zone"
  value       = var.create_zone ? aws_route53_zone.main[0].name_servers : data.aws_route53_zone.existing[0].name_servers
}

output "zone_name" {
  description = "Name of the Route53 zone"
  value       = var.domain_name
}

output "records" {
  description = "Map of created DNS records"
  value = {
    for k, record in aws_route53_record.records : k => {
      name  = record.name
      type  = record.type
      fqdn  = record.fqdn
    }
  }
}

output "health_check_ids" {
  description = "Map of health check IDs"
  value = {
    for k, hc in aws_route53_health_check.health_checks : k => hc.id
  }
}
