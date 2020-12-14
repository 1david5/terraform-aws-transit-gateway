############################################################################################################
# Locals
############################################################################################################

locals {
  transit_gateway_id = var.existing_transit_gateway_id != null && var.existing_transit_gateway_id != "" ? var.existing_transit_gateway_id : (var.create_transit_gateway != null ? try(aws_ec2_transit_gateway.this[0].id, null) : null)

  transit_gateway_route_table_id = var.existing_transit_gateway_route_table != null && var.existing_transit_gateway_route_table != "" ? var.existing_transit_gateway_route_table : (var.create_transit_gateway_route_table != null ? try(aws_ec2_transit_gateway_route_table.this[0].id, null) : null)

  tgw_vpc_attachments = var.tgw_config["tgw_vpc_attachments"] != null ? var.tgw_config["tgw_vpc_attachments"] : {}

  tgw_peering_attachments = var.tgw_config["tgw_peering_attachments"] != null ? var.tgw_config["tgw_peering_attachments"] : {}

  tgw_vpc_attachment_accepters = var.tgw_config["tgw_vpc_attachment_accepters"] != null ? var.tgw_config["tgw_vpc_attachment_accepters"] : {}

  tgw_peering_attachment_accepters = var.tgw_config["tgw_peering_attachment_accepters"] != null ? var.tgw_config["tgw_peering_attachment_accepters"] : {}

  all_attachments_and_accepters = merge(local.tgw_vpc_attachments, local.tgw_peering_attachments, local.tgw_vpc_attachment_accepters, local.tgw_peering_attachment_accepters)

  att_and_acc_w_static_routes = { for att, config in local.all_attachments_and_accepters : att => config.static_routes if config.rt_association == true && config.static_routes != null && config.static_routes != [] && try(config.rt_propagation, false) == false }

  static_route_list = flatten([for att, config in local.att_and_acc_w_static_routes : [for i in range(length(config)) : merge({ "att" = att }, tolist(config)[i])]])

  # Need a static route map to build aws_ec2_transit_gateway_route resources since a list/set of maps (local.static_route_list) cannot be used in for_each
  static_route_map = try(zipmap(concat([for att, st_list in local.att_and_acc_w_static_routes : [for i in range(length(st_list)) : "${att}_static_route_${i}"]]...), local.static_route_list), {})

  att_and_acc_w_subnet_routes = { for att, config in merge(local.tgw_vpc_attachments, local.tgw_vpc_attachment_accepters) : att => config.subnet_route_table if config.subnet_route_table != [] && config.subnet_route_table != null }

}

############################################################################################################
# Transit_Gateway
############################################################################################################

resource "aws_ec2_transit_gateway" "this" {
  count = var.create_transit_gateway ? 1 : 0

  amazon_side_asn                 = var.amazon_side_asn
  auto_accept_shared_attachments  = var.auto_accept_shared_attachments
  default_route_table_association = var.default_route_table_association
  default_route_table_propagation = var.default_route_table_propagation
  description                     = coalesce(var.transit_gateway_description, var.transit_gateway_name, "TGW")
  dns_support                     = var.dns_support
  vpn_ecmp_support                = var.vpn_ecmp_support
  tags                            = merge({ "Name" = var.transit_gateway_name }, var.transit_gateway_tags)
}

############################################################################################################
# TGW_Route_Table
############################################################################################################

resource "aws_ec2_transit_gateway_route_table" "this" {
  count = var.create_transit_gateway_route_table ? 1 : 0

  transit_gateway_id = local.transit_gateway_id
  tags = merge(
    { "Name" = var.tgw_route_table_name },
    var.transit_gateway_route_table_tags
  )
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  for_each = { for att, config in local.all_attachments_and_accepters : att => config if config.rt_association == true }

  transit_gateway_route_table_id = local.transit_gateway_route_table_id
  transit_gateway_attachment_id = (contains(keys(local.tgw_vpc_attachments), each.key) ? aws_ec2_transit_gateway_vpc_attachment.this[each.key].id :
    (contains(keys(local.tgw_vpc_attachment_accepters), each.key) ? aws_ec2_transit_gateway_vpc_attachment_accepter.this[each.key].id :
      (contains(keys(local.tgw_peering_attachments), each.key) ? aws_ec2_transit_gateway_peering_attachment.this[each.key].id :
        (contains(keys(local.tgw_peering_attachment_accepters), each.key) ? aws_ec2_transit_gateway_peering_attachment_accepter.this[each.key].id : null
  ))))
}

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  for_each = { for att, config in merge(local.tgw_vpc_attachments, local.tgw_vpc_attachment_accepters) : att => config if config.rt_association == true && config.rt_propagation == true }

  transit_gateway_attachment_id = (contains(keys(local.tgw_vpc_attachments), each.key) ? aws_ec2_transit_gateway_vpc_attachment.this[each.key].id :
    (contains(keys(local.tgw_vpc_attachment_accepters), each.key) ? aws_ec2_transit_gateway_vpc_attachment_accepter.this[each.key].id : null
  ))
  transit_gateway_route_table_id = local.transit_gateway_route_table_id
}

resource "aws_ec2_transit_gateway_route" "this" {
  for_each = local.static_route_map

  transit_gateway_attachment_id = (contains(keys(local.tgw_vpc_attachments), each.value.att) ? aws_ec2_transit_gateway_vpc_attachment.this[each.value.att].id :
    (contains(keys(local.tgw_vpc_attachment_accepters), each.value.att) ? aws_ec2_transit_gateway_vpc_attachment_accepter.this[each.value.att].id :
      (contains(keys(local.tgw_peering_attachments), each.value.att) ? aws_ec2_transit_gateway_peering_attachment.this[each.value.att].id :
        (contains(keys(local.tgw_peering_attachment_accepters), each.key.att) ? aws_ec2_transit_gateway_peering_attachment_accepter.this[each.value.att].id : null
  ))))
  transit_gateway_route_table_id = local.transit_gateway_route_table_id
  destination_cidr_block         = each.value.destination_cidr_block
  blackhole                      = each.value.blackhole
}
############################################################################################################
# TGW_Peering
############################################################################################################

resource "aws_ec2_transit_gateway_peering_attachment" "this" {
  for_each                = local.tgw_peering_attachments
  peer_account_id         = each.value.peer_account_id
  peer_region             = each.value.peer_region
  peer_transit_gateway_id = each.value.peer_transit_gateway_id
  transit_gateway_id      = local.transit_gateway_id
  tags                    = each.value.tags
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "this" {
  for_each                      = local.tgw_peering_attachment_accepters
  transit_gateway_attachment_id = each.value.transit_gateway_attachment_id
  tags                          = each.value.tags
}

############################################################################################################
# TGW_VPC
############################################################################################################

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each                                        = local.tgw_vpc_attachments
  subnet_ids                                      = each.value.subnet_id
  transit_gateway_id                              = local.transit_gateway_id
  vpc_id                                          = each.value.vpc_id
  dns_support                                     = "enable"
  ipv6_support                                    = "disable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags                                            = each.value.tags
  lifecycle {
    ignore_changes = [
      transit_gateway_default_route_table_association,
      transit_gateway_default_route_table_propagation
    ]
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "this" {
  for_each                                        = local.tgw_vpc_attachment_accepters
  transit_gateway_attachment_id                   = each.value.transit_gateway_attachment_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags                                            = each.value.tags
}

############################################################################################################
# Subnet_Route
############################################################################################################
module "subnet_route" {
  source             = "./modules/subnet_route"
  for_each           = local.att_and_acc_w_subnet_routes
  transit_gateway_id = local.transit_gateway_id
  attachment_name    = each.key
  attachment_config  = each.value
}
