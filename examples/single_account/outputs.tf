# output "account_id" {
#   value = data.aws_caller_identity.current.account_id
# }

output "transit_gateway_a" {
  value = module.transit_gateway_a.tgw_module_configuration
}

# output "transit_gateway_b" {
#   value = module.transit_gateway_b.tgw_module_configuration
# }

# output "transit_gateway_b_att_ids" {
#   value = module.transit_gateway_b.tgw_peering_attachment_ids
# }
