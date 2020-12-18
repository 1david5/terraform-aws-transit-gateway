############################################################################################################
# region_a resources
############################################################################################################

module "vpc_a" {
  source = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=master"
  providers = {
    aws = aws.region_a
  }
  namespace  = "eg"
  stage      = "test"
  name       = "app"
  cidr_block = var.vpc_a_cidr_block
}

module "dynamic_subnets_a" {
  source = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=master"
  providers = {
    aws = aws.region_a
  }
  namespace           = "eg"
  stage               = "test"
  name                = "app"
  availability_zones  = ["${var.region_a}a", "${var.region_a}b"]
  vpc_id              = module.vpc_a.vpc_id
  igw_id              = module.vpc_a.igw_id
  cidr_block          = module.vpc_a.vpc_cidr_block
  nat_gateway_enabled = false
}

# module "vpc_aa" {
#   source = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=master"
#   providers = {
#     aws = aws.region_a
#   }
#   namespace  = "eg"
#   stage      = "test"
#   name       = "app2"
#   cidr_block = var.vpc_aa_cidr_block
# }

# module "dynamic_subnets_aa" {
#   source = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=master"
#   providers = {
#     aws = aws.region_a
#   }
#   namespace          = "eg"
#   stage              = "test"
#   name               = "app2"
#   availability_zones = ["us-east-1a", "us-east-1b"]
#   vpc_id             = module.vpc_aa.vpc_id
#   igw_id             = module.vpc_aa.igw_id
#   cidr_block         = var.vpc_aa_cidr_block
#   nat_gateway_enabled     = false
# }

locals {
  tgw_config = {
    tgw_vpc_attachments = {
      vpc_att_1 = {
        vpc_id         = module.vpc_a.vpc_id
        subnet_id      = module.dynamic_subnets_a.private_subnet_ids
        rt_association = true
        rt_propagation = true
        subnet_route_table = [
          {
            route_table_ids      = module.dynamic_subnets_a.private_route_table_ids
            route_to_cidr_blocks = [var.vpc_aa_cidr_block]
          },
        ]
        static_routes = null
        tags          = {}
      }

      # vpc_att_2 = {
      #   vpc_id         = module.vpc_aa.vpc_id
      #   subnet_id      = module.dynamic_subnets_aa.private_subnet_ids
      #   rt_association = true
      #   rt_propagation = false
      #   subnet_route_table = [
      #     {
      #       route_table_ids      = concat(module.dynamic_subnets_aa.private_route_table_ids, module.dynamic_subnets_aa.public_route_table_ids)
      #       route_to_cidr_blocks = [var.vpc_a_cidr_block]
      #     }
      #   ]
      #   static_routes = [
      #     {
      #       blackhole              = false
      #       destination_cidr_block = "10.1.0.0/25"
      #     }
      #   ]
      #   tags = {}
      # }
    }
    tgw_vpc_attachment_accepters = null

    tgw_peering_attachments = null

    tgw_peering_attachment_accepters = null
  }
}

module "transit_gateway_a" {
  source = "../.."
  providers = {
    aws = aws.region_a
  }

  create_transit_gateway = true

  transit_gateway_name = "region_a_tgw"

  create_transit_gateway_route_table = true

  tgw_route_table_name = "region_a_tgw_rt"

  tgw_config = local.tgw_config

}

############################################################################################################
# region_b resources
############################################################################################################
# module "vpc_b" {
#   source = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=master"
#   providers = {
#     aws = aws.region_b
#   }
#   namespace  = "eg"
#   stage      = "test"
#   name       = "app3"
#   cidr_block = var.vpc_b_cidr_block
# }

# module "dynamic_subnets_b" {
#   source = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=master"
#   providers = {
#     aws = aws.region_b
#   }
#   namespace          = "eg"
#   stage              = "test"
#   name               = "app3"
#   availability_zones = ["us-east-2a", "us-east-2b"]
#   vpc_id             = module.vpc_b.vpc_id
#   igw_id             = module.vpc_b.igw_id
#   cidr_block         = var.vpc_b_cidr_block
#   nat_gateway_enabled     = false
# }

# data "aws_caller_identity" "current" {}

# module "transit_gateway_b" {
#   source = "../.."
#   providers = {
#     aws = aws.region_b
#   }

#   create_transit_gateway = true

#   transit_gateway_name = "region_b_tgw"

#   create_transit_gateway_route_table = true

#   tgw_route_table_name = "region_b_tgw_rt"

#   tgw_config = {
#     tgw_vpc_attachments = {
#       vpc_att_1 = {
#         vpc_id         = module.vpc_b.vpc_id
#         subnet_id      = module.dynamic_subnets_b.private_subnet_ids
#         rt_association = true
#         rt_propagation = true
#         subnet_route_table = [
#           {
#             route_table_ids      = concat(module.dynamic_subnets_b.private_route_table_ids, module.dynamic_subnets_b.public_route_table_ids)
#             route_to_cidr_blocks = [var.vpc_a_cidr_block]
#           }
#         ]
#         static_routes = null
#         tags          = {}
#       }

#     }
#     tgw_vpc_attachment_accepters = null

#     tgw_peering_attachments = {
#       region_a_peer = {
#         peer_account_id         = null
#         peer_region             = var.region_a
#         peer_transit_gateway_id = module.transit_gateway_a.transit_gateway_id
#         rt_association          = false
#         static_routes = [
#           # {
#           #   blackhole              = false
#           #   destination_cidr_block = var.vpc_a_cidr_block
#           # }
#         ]
#         tags = {}
#       }
#     }

#     tgw_peering_attachment_accepters = null
#   }

#   depends_on = [module.dynamic_subnets_b]
# }

variable "tgw_config" {
  default = {
    tgw_vpc_attachments = {
      vpc_att_1 = {
        vpc_id         = "module.vpc_a.vpc_id"
        subnet_id      = "module.dynamic_subnets_a.private_subnet_ids"
        rt_association = true
        rt_propagation = true
        subnet_route_table = [
          {
            route_table_ids      = "[rt-id213432432, rt-idasdfasdfds]"
            route_to_cidr_blocks = "[11.1.1.1/16, 2.2.2.2/16]"
          },
          {
            route_table_ids      = "[rt-idsdfasdf, rt-igjghjjhk]"
            route_to_cidr_blocks = "[3.3.3.3/16, 4.4.4.4/16]"
          },
        ]
        static_routes = null
        tags          = {}
      }

    }
    tgw_vpc_attachment_accepters = null

    tgw_peering_attachments = null

    tgw_peering_attachment_accepters = null
  }

}

# locals {
#   transit_gateway_id = var.existing_tranist_gateway_id != null && var.existing_tranist_gateway_id != "" ? var.existing_tranist_gateway_id : (var.create_transit_gateway != null ? try(aws_ec2_transit_gateway.this[0].id, null) : null)

#   transit_gateway_route_table_id = var.existing_tranist_gateway_route_table != null && var.existing_tranist_gateway_route_table != "" ? var.existing_tranist_gateway_route_table : (var.create_transit_gateway_route_table != null ? try(aws_ec2_transit_gateway_route_table.this[0].id, null) : null)

#   tgw_vpc_attachments = var.tgw_config["tgw_vpc_attachments"] != null ? var.tgw_config["tgw_vpc_attachments"] : {}

#   tgw_peering_attachments = var.tgw_config["tgw_peering_attachments"] != null ? var.tgw_config["tgw_peering_attachments"] : {}

#   tgw_vpc_attachment_accepters = var.tgw_config["tgw_vpc_attachment_accepters"] != null ? var.tgw_config["tgw_vpc_attachment_accepters"] : {}

#   tgw_peering_attachment_accepters = var.tgw_config["tgw_peering_attachment_accepters"] != null ? var.tgw_config["tgw_peering_attachment_accepters"] : {}

#   all_attachments_and_accepters = merge(local.tgw_vpc_attachments, local.tgw_peering_attachments, local.tgw_vpc_attachment_accepters, local.tgw_peering_attachment_accepters)

#   att_and_acc_w_static_routes = { for att, config in local.all_attachments_and_accepters : att => config.static_routes if config.rt_association == true && config.static_routes != null && config.static_routes != [] && try(config.rt_propagation, false) == false }

#   static_route_list = flatten([for att, config in local.att_and_acc_w_static_routes : [for i in range(length(config)) : merge({ "att" = att }, tolist(config)[i])]])

#   # Need a static route map to build aws_ec2_transit_gateway_route resources since a list/set of maps (local.static_route_list) cannot be used in for_each
#   static_route_map = try(zipmap(concat([for att, st_list in local.att_and_acc_w_static_routes : [for i in range(length(st_list)) : "${att}_static_route_${i}"]]...), local.static_route_list), {})

#   att_and_acc_w_subnet_routes = { for att, config in merge(local.tgw_vpc_attachments, local.tgw_vpc_attachment_accepters) : att => config.subnet_route_table if config.subnet_route_table != [] && config.subnet_route_table != null }

# }
