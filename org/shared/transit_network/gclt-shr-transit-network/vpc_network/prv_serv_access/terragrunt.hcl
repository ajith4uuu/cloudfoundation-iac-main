# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
locals {
}

terraform {
  source = "github.com/colt-net/terraform-modules//modules/private_service_access?ref=v1.0.0"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders("org.hcl")
}

dependency "parent" {
  config_path = "../../../gclt-shr-transit-network/"
  mock_outputs = {
    project = {
      project_id = "gclt-shr-transit-network"
    }
    labels = {
      resource_name = "gclt-shr-transit-network"
    }
  }
}

dependency "network" {
  config_path = "../../vpc_network/"
  mock_outputs = {
    vpc = {
      network = {
        network_id = "mock"
      }
    }
  }
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {

  project_id          = dependency.parent.outputs.project.project_id
  global_address_name = "${dependency.parent.outputs.labels.resource_name}-services"
  network_name        = dependency.network.outputs.vpc.network.network_id
  prefix_length       = 24
  address             = "10.110.65.0"
}