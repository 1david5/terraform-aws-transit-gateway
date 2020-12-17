## terraform-aws-transit-gateway

### Terraform module to provision:

* [AWS Transit Gateway](https://aws.amazon.com/transit-gateway/)
* [Transit Gateway route table](https://docs.aws.amazon.com/vpc/latest/tgw/tgw-route-tables.html)
* [Transit Gateway VPC attachments](https://docs.aws.amazon.com/vpc/latest/tgw/tgw-vpc-attachments.html)
* [Transit Gateway VPC attachment accepters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment_accepter)
* [Transit Gateway peering attachments](https://docs.aws.amazon.com/vpc/latest/tgw/tgw-peering.html)
* [Transit Gateway peering attachment accepters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_peering_attachment_accepter)
* Transit Gateway route table associations to allow traffic from the vpc or peering attachments to the Transit Gateway
* Transit Gateway route table propagations to propagate attachment associations to the Transit Gateway route table and create routes to these attachments
* Transit Gateway static routes to route traffic from the Transit Gateway to the corresponding attachment. (static routes have a higher precedence than propagated routes)
* Subnet routes to route traffic from the subnets to the Transit Gateway

## Introduction

This module is configurable via a few transit gateway and route table specific variables but mainly via the variable `tgw_config` which defines all attachments and accepters associated with the Transit Gateway.

The variable `tgw_config` is an object with four keys:

* `tgw_vpc_attachments`
* `tgw_vpc_attachment_accepters`
* `tgw_peering_attachments`
* `tgw_peering_attachment_accepters`

The value of each of these keys is a map of objects with the attachment/accepter name as key and its configuration as value. Below we are providing a brief description of these elements and their field:

<<<<<<< HEAD
* ### `tgw_vpc_attachments`
=======
>>>>>>> update README with module and variable tgw_config descriptions
  * `vpc_id` - The ID of the VPC for which to create a VPC attachment
  * `subnet_id` - The IDs of the subnets in the VPC where the transit gateway will be attached to.
  * `rt_association` - Whether to enable route table association for the VPC attachment.
  * `rt_propagation` - Whether to enable route table propagation for the VPC attachment.
  * `static_route` - A set of objects with two elements describing the list of routes that will be added to the transit gateway route table pointing to the attachments. It only takes effect if `rt_propagation` is set to `false`.
    * `blackhole` - Whether the static route is a blackhole.
    * `destination_cidr_block` - CIDR block for individual route
  * `tags` - Tags for the Transit Gateway VPC attachment.
<<<<<<< HEAD
* ### `tgw_vpc_attachment_accepters`
=======
>>>>>>> update README with module and variable tgw_config descriptions
  * `transit_gateway_attachment_id` - The ID of the VPC attachment to accept.
  * `rt_association` - Whether to enable route table association for the VPC accepter.
  * `rt_propagation` - Whether to enable route table propagation for the VPC accepter.
  * `transit_gateway_default_route_table_association` - Whether to associate the accepter with the default route table if existing.
  * `transit_gateway_default_route_table_propagation` - Whether to propagate the accepter route to the default route table if existing.
  * `static_routes` - A set of objects with two elements describing the list of routes that will be added to the transit gateway route table pointing to the accepted VPC attachment. It only takes effect if `rt_propagation` is set to `false`.
    * `blackhole` - Whether the static route is a blackhole.
    * `destination_cidr_block` - CIDR block for individual route
  * `tags` - Tags for the Transit Gateway VPC accepter
<<<<<<< HEAD
* ### `tgw_peering_attachments`
=======

>>>>>>> update README with module and variable tgw_config descriptions
  * `peer_account_id` - The account ID of the transit gateway to peer with. Mandatory if the peer is in a different account from the one the AWS provider si currently connected to.
  * `peer_region` - The region of the transit gateway to peer with.
  * `peer_transit_gateway_id` -
  * `rt_association` - Whether to enable route table association for the peering attachment.
  * `static_routes` - A set of objects with two elements describing the list of routes that will be added to the transit gateway route table pointing to the peer transit gateway.
    * `blackhole` - Whether the static route is a blackhole.
    * `destination_cidr_block` - CIDR block for individual route
  * `tags` - Tags for the Transit Gateway peer attachment.
<<<<<<< HEAD
* ### `tgw_peering_attachment_accepters`
=======
>>>>>>> update README with module and variable tgw_config descriptions
  * `transit_gateway_attachment_id` - The ID of the peering attachment to accept.
  * `rt_association` - Whether to enable route table association for the peer accepter.
  * `static_routes` - A set of objects with two elements describing the list of routes that will be added to the transit gateway route table pointing to the accepted peer transit gateway.
    * `blackhole` - Whether the static route is a blackhole.
    * `destination_cidr_block` - CIDR block for individual route
  * `tags` - Tags for the Transit Gateway peer accepter.



<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<<<<<<< HEAD
=======

>>>>>>> update README with module and variable tgw_config descriptions
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
| existing\_transit\_gateway\_id | Existing Transit Gateway ID. If provided, the module will not create a Transit Gateway but instead will use the existing one | `string` | `null` | no |
| existing\_transit\_gateway\_route\_table | Existing Transit Gateway Route Table ID. If provided, the module will not create a Transit Gateway Route Table but instead will use the existing one | `string` | `null` | no |
<<<<<<< HEAD
| tgw\_config | Configuration for VPC attachments, TGW peering attachments, Route Table association, propagation, static routes and VPC and TGW accepters. Set key's values to `null` to prevent resource creation | <pre>object({<br><br>    tgw_vpc_attachments = map(object({<br>      vpc_id         = string<br>      subnet_id      = set(string)<br>      rt_association = bool<br>      rt_propagation = bool<br>      static_routes = set(object({<br>        blackhole              = bool<br>        destination_cidr_block = string<br>      }))<br>      tags = map(string)<br>    }))<br><br>    tgw_vpc_attachment_accepters = map(object({<br>      transit_gateway_attachment_id                   = string<br>      rt_association                                  = bool<br>      rt_propagation                                  = bool<br>      transit_gateway_default_route_table_association = bool<br>      transit_gateway_default_route_table_propagation = bool<br>      static_routes = set(object({<br>        blackhole              = bool<br>        destination_cidr_block = string<br>      }))<br>      tags = map(string)<br>    }))<br><br>    tgw_peering_attachments = map(object({<br>      peer_account_id         = string<br>      peer_region             = string<br>      peer_transit_gateway_id = string<br>      rt_association          = bool<br>      static_routes = set(object({<br>        blackhole              = bool<br>        destination_cidr_block = string<br>      }))<br>      tags = map(string)<br>    }))<br><br>    tgw_peering_attachment_accepters = map(object({<br>      transit_gateway_attachment_id = string<br>      rt_association                = bool<br>      static_routes = set(object({<br>        blackhole              = bool<br>        destination_cidr_block = string<br>      }))<br>      tags = map(string)<br>    }))<br>  })</pre> | `null` | no |
=======
>>>>>>> update README with module and variable tgw_config descriptions
| tgw\_route\_table\_name | (optional) name of transit gateway route tables want to create besides the default route table | `string` | `null` | no |
| transit\_gateway\_description | (Optional) Description of the EC2 Transit Gateway. | `string` | `""` | no |
| transit\_gateway\_name | Name for the new transit gateway | `string` | `null` | no |
| transit\_gateway\_route\_table\_tags | (Optional) Key-value tags for the EC2 Transit Gateway Route Table. | `map(string)` | `{}` | no |
| transit\_gateway\_tags | (Optional) Key-value tags for the EC2 Transit Gateway. | `map(string)` | `{}` | no |
| vpn\_ecmp\_support | (Optional) Whether VPN Equal Cost Multipath Protocol support is enabled. Valid values: disable, enable | `string` | `"enable"` | no |

## Outputs

| Name | Description |
|------|-------------|
| tgw\_module\_configuration | Map with all data from TGW, route table, associations, propagations, routes and accepters created by this module |
| tgw\_peering\_attachment\_ids | IDs of the transit gateway peering attachments |
<<<<<<< HEAD
| transit\_gateway\_id | Transit Gateway identifier |
=======
>>>>>>> update README with module and variable tgw_config descriptions

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
