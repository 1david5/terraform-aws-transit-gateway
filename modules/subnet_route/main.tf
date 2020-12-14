locals {
  subnet_route_list = try(concat([for pair in var.attachment_config : setproduct(tolist(pair.route_table_ids), tolist(pair.route_to_cidr_blocks))]...), [])

  subnet_route_name_list = [for i in range(length(local.subnet_route_list)) : "${var.attachment_name}_route_${i}"]

  subnet_route_map = try(zipmap(local.subnet_route_name_list, local.subnet_route_list), {})
}

resource "aws_route" "this" {
  for_each               = local.subnet_route_map
  transit_gateway_id     = var.transit_gateway_id
  route_table_id         = each.value[0]
  destination_cidr_block = each.value[1]
}

variable "attachment_name" {
  type        = string
  description = "Name of the VPC attachement or accepter"
}

variable "attachment_config" {
  type = set(object({
    route_table_ids      = set(string)
    route_to_cidr_blocks = set(string)
  }))
  description = "Configuration parameters of the VPC attachment or accepter"
}

variable "transit_gateway_id" {
  type        = string
  description = "ID of the transit gateway where traffic will be routed to"
}
