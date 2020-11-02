## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 3.5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| amazon\_side\_asn | (Optional) Private Autonomous System Number (ASN) for the Amazon side of a BGP session. The range is 64512 to 65534 for 16-bit ASNs and 4200000000 to 4294967294 for 32-bit ASNs. | `number` | `64512` | no |
| auto\_accept\_shared\_attachments | (Optional) Whether resource attachment requests are automatically accepted. Valid values: disable, enable | `string` | `"disable"` | no |
| create\_transit\_gateway | Whether to create a Transit Gateway. If set to `false`, an existing Transit Gateway ID must be provided in the variable `existing_transit_gateway_id` | `bool` | `true` | no |
| create\_transit\_gateway\_route\_table | Whether to create a Transit Gateway Route Table. If set to `false`, an existing Transit Gateway Route Table ID must be provided in the variable `existing_transit_gateway_route_table_id` | `bool` | `true` | no |
| default\_route\_table\_association | (Optional) Whether resource attachments are automatically associated with the default association route table. Valid values: disable, enable | `string` | `"disable"` | no |
| default\_route\_table\_propagation | (Optional) Whether resource attachments automatically propagate routes to the default propagation route table. Valid values: disable, enable | `string` | `"disable"` | no |
| dns\_support | (Optional) Whether DNS support is enabled. Valid values: disable, enable | `string` | `"enable"` | no |
| existing\_tranist\_gateway\_id | Existing Transit Gateway ID. If provided, the module will not create a Transit Gateway but instead will use the existing one | `string` | `null` | no |
| existing\_tranist\_gateway\_route\_table | Existing Transit Gateway Route Table ID. If provided, the module will not create a Transit Gateway Route Table but instead will use the existing one | `string` | `null` | no |
| tgw\_config | n/a | <pre>object({<br><br>    tgw_vpc_attachments = map(object({<br>      vpc_id         = string<br>      subnet_id      = set(string)<br>      rt_association = bool<br>      rt_propagation = bool<br>      static_routes = set(object({<br>        blackhole              = bool<br>        destination_cidr_block = string<br>      }))<br>      tags = map(string)<br>    }))<br><br>    tgw_vpc_attachment_accepters = map(object({<br>      transit_gateway_attachment_id                   = string<br>      rt_association                                  = bool<br>      rt_propagation                                  = bool<br>      transit_gateway_default_route_table_association = bool<br>      transit_gateway_default_route_table_propagation = bool<br>      static_routes = set(object({<br>        blackhole              = bool<br>        destination_cidr_block = string<br>      }))<br>      tags = map(string)<br>    }))<br><br>    tgw_peering_attachments = map(object({<br>      peer_account_id         = string<br>      peer_region             = string<br>      peer_transit_gateway_id = string<br>      rt_association          = bool<br>      static_routes = set(object({<br>        blackhole              = bool<br>        destination_cidr_block = string<br>      }))<br>      tags = map(string)<br>    }))<br><br>    tgw_peering_attachment_accepters = map(object({<br>      transit_gateway_attachment_id = string<br>      rt_association                = bool<br>      static_routes = set(object({<br>        blackhole              = bool<br>        destination_cidr_block = string<br>      }))<br>      tags = map(string)<br>    }))<br>  })</pre> | n/a | yes |
| tgw\_route\_table\_name | (optional) name of transit gateway route tables want to create besides the default route table | `string` | `null` | no |
| transit\_gateway\_description | (Optional) Description of the EC2 Transit Gateway. | `string` | `""` | no |
| transit\_gateway\_name | Name for the new transit gateway | `string` | `null` | no |
| transit\_gateway\_route\_table\_tags | (Optional) Key-value tags for the EC2 Transit Gateway Route Table. | `map(string)` | `{}` | no |
| transit\_gateway\_tags | (Optional) Key-value tags for the EC2 Transit Gateway. | `map(string)` | `{}` | no |
| vpn\_ecmp\_support | (Optional) Whether VPN Equal Cost Multipath Protocol support is enabled. Valid values: disable, enable | `string` | `"enable"` | no |

## Outputs

| Name | Description |
|------|-------------|
| tgw\_module\_configuration | n/a |
| tgw\_peering\_attachment\_ids | IDs of the transit gateway peering attachments |
| transit\_gateway\_id | EC2 Transit Gateway identifier |
