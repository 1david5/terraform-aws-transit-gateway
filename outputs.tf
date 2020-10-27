##############################################################################################
# aws_ec2_transit_gateway
##############################################################################################

# output "transit_gateway_arn" {
#   description = "EC2 Transit Gateway Amazon Resource Name (ARN)"
#   value       = aws_ec2_transit_gateway.this[*].arn
# }

# output "tgw_association_default_route_table_id" {
#   description = "Identifier of the default association route table"
#   value       = aws_ec2_transit_gateway.this[*].association_default_route_table_id
# }

output "transit_gateway_id" {
  description = "EC2 Transit Gateway identifier"
  value       = try(aws_ec2_transit_gateway.this[0].id, null)
}

# output "transit_gateway_owner_id" {
#   description = "Identifier of the AWS account that owns the EC2 Transit Gateway"
#   value       = aws_ec2_transit_gateway.this[*].owner_id
# }

# output "transit_gateway_propagation_default_route_table_id" {
#   description = "Identifier of the default propagation route table"
#   value       = aws_ec2_transit_gateway.this[*].propagation_default_route_table_id
# }

##############################################################################################
# aws_ec2_transit_gateway_route_table
##############################################################################################

# output "default_association_route_table" {
#   description = "Boolean whether this is the default association route table for the EC2 Transit Gateway."
#   value       = { for rt in var.tgw_route_table_names : rt => aws_ec2_transit_gateway_route_table.transit_gateway_route_table[rt].default_association_route_table }
# }

# output "default_propagation_route_table" {
#   description = "Boolean whether this is the default propagation route table for the EC2 Transit Gateway."
#   value       = { for rt in var.tgw_route_table_names : rt => aws_ec2_transit_gateway_route_table.transit_gateway_route_table[rt].default_propagation_route_table }
# }

# output "transit_gateway_route_table_id" {
#   value = { for rt in var.tgw_route_table_names : rt => aws_ec2_transit_gateway_route_table.transit_gateway_route_table[rt].id }
# }

##############################################################################################
# TGW Peering Attachment and Accepter
##############################################################################################

output "tgw_peering_attachment_ids" {
  description = "IDs of the transit gateway peering attachments"
  value       = { for att, att_config in local.tgw_peering_attachments : att => aws_ec2_transit_gateway_peering_attachment.this[att].id }
}

output "tgw_module_configuration" {
  value = {
    "tgw_name" = try(aws_ec2_transit_gateway.this[0].tags["Name"], null)
    "tgw_id"   = try(aws_ec2_transit_gateway.this[0].id, null)
    "tgw_arn"  = try(aws_ec2_transit_gateway.this[0].arn, null)
    "owner_id" = try(aws_ec2_transit_gateway.this[0].owner_id, null)
    "rt_name"  = try(aws_ec2_transit_gateway_route_table.this[0].tags["Name"], null)
    "rt_id"    = try(aws_ec2_transit_gateway_route_table.this[0].id, null)
    "tgw_vpc_attachments" = try(
      { for att, config in var.tgw_config.tgw_vpc_attachments :
        att => merge(aws_ec2_transit_gateway_vpc_attachment.this[att],
          try({ "att_association" = aws_ec2_transit_gateway_route_table_association.this[att] }, {}),
          try({ "att_propagation" = aws_ec2_transit_gateway_route_table_propagation.this[att] }, {}),
          try({ "att_static_routes" = { for sr_att, route in local.static_route_map : sr_att => aws_ec2_transit_gateway_route.this[sr_att] if route.att == att } }, {})
        )
    }, {})

    "tgw_vpc_attachment_accepters" = try(
      { for att, config in var.tgw_config.tgw_vpc_attachment_accepters :
        att => merge(aws_ec2_transit_gateway_vpc_attachment_accepter.this[att],
          try({ "att_association" = aws_ec2_transit_gateway_route_table_association.this[att] }, {}),
          try({ "att_propagation" = aws_ec2_transit_gateway_route_table_propagation.this[att] }, {}),
          try({ "att_static_routes" = { for sr_att, route in local.static_route_map : sr_att => aws_ec2_transit_gateway_route.this[sr_att] if route.att == att } }, {})
        )
    }, {})

    "tgw_peering_attachments" = try(
      { for att, config in var.tgw_config.tgw_peering_attachments :
        att => merge(aws_ec2_transit_gateway_peering_attachment.this[att],
          try({ "att_association" = aws_ec2_transit_gateway_route_table_association.this[att] }, {}),
          try({ "att_propagation" = aws_ec2_transit_gateway_route_table_propagation.this[att] }, {}),
          try({ "att_static_routes" = { for sr_att, route in local.static_route_map : sr_att => aws_ec2_transit_gateway_route.this[sr_att] if route.att == att } }, {})
        )
    }, {})

    "tgw_peering_attachment_accepters" = try(
      { for att, config in var.tgw_config.tgw_peering_attachment_accepters :
        att => merge(aws_ec2_transit_gateway_peering_attachment_accepter.this[att],
          try({ "att_association" = aws_ec2_transit_gateway_route_table_association.this[att] }, {}),
          try({ "att_propagation" = aws_ec2_transit_gateway_route_table_propagation.this[att] }, {}),
          try({ "att_static_routes" = { for sr_att, route in local.static_route_map : sr_att => aws_ec2_transit_gateway_route.this[sr_att] if route.att == att } }, {})
        )
    }, {})
  }
}