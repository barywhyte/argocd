locals {
  resource_name = "es-domain"
  instance_count         = 6
  version                = "6.3"
  instance_type          = "m5.2xlarge.elasticsearch"
  volume_size            = 170
  dedicated_master_count = null
  dedicated_master_type  = "t3.small.elasticsearch"
  alert_channels         = []

}

resource "aws_elasticsearch_domain" "elasticsearch_cluster" {
  domain_name           = local.resource_name
  elasticsearch_version = 1.0

  cluster_config {
    instance_type            = local.instance_type
    instance_count           = local.instance_count
    dedicated_master_enabled = true
    dedicated_master_count   = local.dedicated_master_count
    dedicated_master_type    = local.dedicated_master_type
    zone_awareness_enabled = true

    zone_awareness_config {
      availability_zone_count = length(var.aws_subnet_ids)
    }
  }

  ebs_options {
    ebs_enabled = true
    volume_size = local.volume_size
  }

  snapshot_options {
    automated_snapshot_start_hour = 4
  }

  vpc_options {
    subnet_ids         = var.aws_subnet_ids[*]
    #security_group_ids = var.aws_security_group_ids
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = true
    "indices.fielddata.cache.size"           = 20
    "indices.query.bool.max_clause_count"    = 1024
    "override_main_response_version"         = false
  }
  access_policies = <<POLICY
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "es:*",
      "Resource": "arn:aws:es:us-east-1:55*********:domain/${local.resource_name}/*"
    }
  ]
}
POLICY

  tags = {
    Name                = local.resource_name

  }
  lifecycle {
    ignore_changes = [log_publishing_options, advanced_options]
  }
  encrypt_at_rest {
    enabled = var.encryption_at_rest

  }

}
