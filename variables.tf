variable "tgw_config" {
  type = object({

    tgw_vpc_attachments = map(object({
      vpc_id         = string
      subnet_id      = set(string)
      rt_association = bool
      rt_propagation = bool
      static_routes = set(object({
        blackhole              = bool
        destination_cidr_block = string
      }))
      tags = map(string)
    }))

    tgw_vpc_attachment_accepters = map(object({
      transit_gateway_attachment_id                   = string
      rt_association                                  = bool
      rt_propagation                                  = bool
      transit_gateway_default_route_table_association = bool
      transit_gateway_default_route_table_propagation = bool
      static_routes = set(object({
        blackhole              = bool
        destination_cidr_block = string
      }))
      tags = map(string)
    }))

    tgw_peering_attachments = map(object({
      peer_account_id         = string
      peer_region             = string
      peer_transit_gateway_id = string
      rt_association          = bool
      static_routes = set(object({
        blackhole              = bool
        destination_cidr_block = string
      }))
      tags = map(string)
    }))

    tgw_peering_attachment_accepters = map(object({
      transit_gateway_attachment_id = string
      rt_association                = bool
      static_routes = set(object({
        blackhole              = bool
        destination_cidr_block = string
      }))
      tags = map(string)
    }))
  })
  description = "Configuration for VPC attachments, TGW peering attachments, Route Table association, propagation, static routes and VPC and TGW accepters. Set key's values to `null` to prevent resource creation"
  default     = null
}

##############################################################################################
# aws_ec2_transit_gateway
##############################################################################################
variable "existing_tranist_gateway_id" {
  type        = string
  description = "Existing Transit Gateway ID. If provided, the module will not create a Transit Gateway but instead will use the existing one"
  default     = null
}

variable "create_transit_gateway" {
  type        = bool
  description = "Whether to create a Transit Gateway. If set to `false`, an existing Transit Gateway ID must be provided in the variable `existing_transit_gateway_id`"
  default     = true
}

variable "transit_gateway_name" {
  type        = string
  description = "Name for the new transit gateway"
  default     = null
}

variable "amazon_side_asn" {
  type        = number
  description = "(Optional) Private Autonomous System Number (ASN) for the Amazon side of a BGP session. The range is 64512 to 65534 for 16-bit ASNs and 4200000000 to 4294967294 for 32-bit ASNs."
  default     = 64512
}

variable "auto_accept_shared_attachments" {
  type        = string
  description = "(Optional) Whether resource attachment requests are automatically accepted. Valid values: disable, enable"
  default     = "disable"
}

variable "default_route_table_association" {
  type        = string
  description = "(Optional) Whether resource attachments are automatically associated with the default association route table. Valid values: disable, enable"
  default     = "disable"
}

variable "default_route_table_propagation" {
  type        = string
  description = " (Optional) Whether resource attachments automatically propagate routes to the default propagation route table. Valid values: disable, enable"
  default     = "disable"
}

variable "transit_gateway_description" {
  type        = string
  description = "(Optional) Description of the EC2 Transit Gateway."
  default     = ""
}

variable "dns_support" {
  type        = string
  description = "(Optional) Whether DNS support is enabled. Valid values: disable, enable"
  default     = "enable"
}

variable "transit_gateway_tags" {
  type        = map(string)
  description = "(Optional) Key-value tags for the EC2 Transit Gateway."
  default     = {}
}

variable "vpn_ecmp_support" {
  type        = string
  description = "(Optional) Whether VPN Equal Cost Multipath Protocol support is enabled. Valid values: disable, enable"
  default     = "enable"
}

##############################################################################################
# aws_ec2_transit_gateway_route_table
##############################################################################################

variable "existing_tranist_gateway_route_table" {
  type        = string
  description = "Existing Transit Gateway Route Table ID. If provided, the module will not create a Transit Gateway Route Table but instead will use the existing one"
  default     = null
}

variable "create_transit_gateway_route_table" {
  type        = bool
  description = "Whether to create a Transit Gateway Route Table. If set to `false`, an existing Transit Gateway Route Table ID must be provided in the variable `existing_transit_gateway_route_table_id`"
  default     = true
}

variable "transit_gateway_route_table_tags" {
  type        = map(string)
  description = "(Optional) Key-value tags for the EC2 Transit Gateway Route Table."
  default     = {}
}

variable "tgw_route_table_name" {
  type        = string
  description = "(optional) name of transit gateway route tables want to create besides the default route table"
  default     = null
}
