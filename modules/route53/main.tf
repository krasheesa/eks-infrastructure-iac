resource "aws_route53_zone" "main" {
  count = var.create_zone ? 1 : 0

  name    = var.domain_name
  comment = var.zone_comment

  dynamic "vpc" {
    for_each = var.is_private_zone ? var.vpc_associations : []
    content {
      vpc_id     = vpc.value.vpc_id
      vpc_region = vpc.value.vpc_region
    }
  }

  force_destroy = var.force_destroy

  tags = merge(
    var.tags,
    {
      Name = var.domain_name
    }
  )
}

data "aws_route53_zone" "existing" {
  count = var.create_zone ? 0 : 1

  name         = var.domain_name
  private_zone = var.is_private_zone
}

locals {
  zone_id = var.create_zone ? aws_route53_zone.main[0].zone_id : data.aws_route53_zone.existing[0].zone_id
}

resource "aws_route53_record" "records" {
  for_each = { for record in var.records : "${record.name}-${record.type}" => record }

  zone_id = local.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = try(each.value.ttl, null)
  records = try(each.value.records, null)

  dynamic "alias" {
    for_each = try(each.value.alias, null) != null ? [each.value.alias] : []
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = try(alias.value.evaluate_target_health, false)
    }
  }

  dynamic "weighted_routing_policy" {
    for_each = try(each.value.weighted_routing_policy, null) != null ? [each.value.weighted_routing_policy] : []
    content {
      weight = weighted_routing_policy.value.weight
    }
  }

  dynamic "latency_routing_policy" {
    for_each = try(each.value.latency_routing_policy, null) != null ? [each.value.latency_routing_policy] : []
    content {
      region = latency_routing_policy.value.region
    }
  }

  dynamic "geolocation_routing_policy" {
    for_each = try(each.value.geolocation_routing_policy, null) != null ? [each.value.geolocation_routing_policy] : []
    content {
      continent   = try(geolocation_routing_policy.value.continent, null)
      country     = try(geolocation_routing_policy.value.country, null)
      subdivision = try(geolocation_routing_policy.value.subdivision, null)
    }
  }

  dynamic "failover_routing_policy" {
    for_each = try(each.value.failover_routing_policy, null) != null ? [each.value.failover_routing_policy] : []
    content {
      type = failover_routing_policy.value.type
    }
  }

  set_identifier  = try(each.value.set_identifier, null)
  health_check_id = try(each.value.health_check_id, null)
  allow_overwrite = try(each.value.allow_overwrite, false)

  depends_on = [
    aws_route53_zone.main
  ]
}

resource "aws_route53_health_check" "health_checks" {
  for_each = { for hc in var.health_checks : hc.name => hc }

  type                            = each.value.type
  resource_path                   = try(each.value.resource_path, null)
  fqdn                            = try(each.value.fqdn, null)
  ip_address                      = try(each.value.ip_address, null)
  port                            = try(each.value.port, null)
  protocol                        = try(each.value.protocol, null)
  request_interval                = try(each.value.request_interval, 30)
  failure_threshold               = try(each.value.failure_threshold, 3)
  measure_latency                 = try(each.value.measure_latency, false)
  enable_sni                      = try(each.value.enable_sni, false)
  search_string                   = try(each.value.search_string, null)
  cloudwatch_alarm_name           = try(each.value.cloudwatch_alarm_name, null)
  cloudwatch_alarm_region         = try(each.value.cloudwatch_alarm_region, null)
  insufficient_data_health_status = try(each.value.insufficient_data_health_status, null)

  tags = merge(
    var.tags,
    {
      Name = each.value.name
    }
  )
}
