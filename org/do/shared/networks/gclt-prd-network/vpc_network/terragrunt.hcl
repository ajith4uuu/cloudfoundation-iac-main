# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
locals {
}

terraform {
  source = "github.com/colt-net/terraform-modules//stacks/vpc_network?ref=v1.0.0"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders("org.hcl")
}

dependency "parent" {
  config_path = "../../gclt-prd-network/"
  mock_outputs = {
    project = {
      project_id = "gclt-prd-network"
    }
    labels = {
      resource_name = "gclt-prd-network"
    }
  }
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {

  project_id   = dependency.parent.outputs.project.project_id
  network_name = "${dependency.parent.outputs.labels.resource_name}-vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = "${dependency.parent.outputs.labels.resource_name}-eu-west1-1"
      subnet_ip             = "10.110.0.0/22"
      subnet_region         = "europe-west1"
      subnet_private_access = true
      subnet_flow_logs      = false
    },
    {
      subnet_name           = "${dependency.parent.outputs.labels.resource_name}-eu-west3-1"
      subnet_ip             = "10.110.16.0/22"
      subnet_region         = "europe-west3"
      subnet_private_access = true
      subnet_flow_logs      = false
    }
  ]

  secondary_ranges = {
    "${dependency.parent.outputs.labels.resource_name}-eu-west1-1" = [
      {
        range_name    = "${dependency.parent.outputs.labels.resource_name}-eu-west1-1-pods"
        ip_cidr_range = "10.110.4.0/24"
      },
      {
        range_name    = "${dependency.parent.outputs.labels.resource_name}-eu-west1-1-services"
        ip_cidr_range = "10.110.5.0/24"
      },
      {
        range_name    = "${dependency.parent.outputs.labels.resource_name}-eu-west1-2-pods"
        ip_cidr_range = "10.110.12.0/23"
      },
      {
        range_name    = "${dependency.parent.outputs.labels.resource_name}-eu-west1-2-services"
        ip_cidr_range = "10.110.14.0/23"
      },
    ],
    "${dependency.parent.outputs.labels.resource_name}-eu-west3-1" = [
      {
        range_name    = "${dependency.parent.outputs.labels.resource_name}-eu-west3-1-pods"
        ip_cidr_range = "10.110.20.0/24"
      },
      {
        range_name    = "${dependency.parent.outputs.labels.resource_name}-eu-west3-1-services"
        ip_cidr_range = "10.110.21.0/24"
      },
      {
        range_name    = "${dependency.parent.outputs.labels.resource_name}-eu-west3-2-pods"
        ip_cidr_range = "10.110.28.0/23"
      },
      {
        range_name    = "${dependency.parent.outputs.labels.resource_name}-eu-west3-2-services"
        ip_cidr_range = "10.110.30.0/23"
      },
    ]
  }

  routes = [
    {
      name              = "private-google-access"
      description       = "Private Google Access for on-premises hosts"
      destination_range = "199.36.153.8/30"
      next_hop_internet = "true"
    }
  ]

}