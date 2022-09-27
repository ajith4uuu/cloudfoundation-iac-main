# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
locals {
}

terraform {
  source = "github.com/colt-net/terraform-modules//stacks/iam_project?ref=v1.0.13"

}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders("org.hcl")
}

dependency "parent" {
  config_path = "../../gclt-nonprod-apigee/"
  mock_outputs = {
    project = {
      project_id = "gclt-nonprod-apigee"
    }
  }
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {

  project_id = dependency.parent.outputs.project.project_id

  editor_members = [
    "user:viswanathan.kandasamy@colt.net",
    "user:ashok.goudar1@colt.net",
    "user:ajith.tenneti@colt.net",
  ]

}