//Create project
resource "tfe_project" "vault-ecs-demo-proj" {
  organization = var.TFC_ORGANIZATION
  name         = "Vault-ECS-Demo"
}
//Create variable set
resource "tfe_variable_set" "vault-ecs-demo-varset" {
  name         = "Vault ECS demo Varset"
  description  = "Some description."
  organization = var.TFC_ORGANIZATION
}
// Variables in variable set
resource "tfe_variable" "aws-secret" {
  key             = "AWS_SECRET_ACCESS_KEY"
  value           = ""
  category        = "env"
  description     = "AWS Secret Key"
  variable_set_id = tfe_variable_set.vault-ecs-demo-varset.id
}

resource "tfe_variable" "hcp-client" {
  key             = "HCP_CLIENT_ID"
  value           = ""
  category        = "env"
  description     = "HCP client ID"
  variable_set_id = tfe_variable_set.vault-ecs-demo-varset.id
}

resource "tfe_variable" "aws-access" {
  key             = "HCP_CLIENT_SECRET"
  value           = ""
  category        = "env"
  description     = "HCP Client Secret"
  variable_set_id = tfe_variable_set.vault-ecs-demo-varset.id
}

resource "tfe_variable" "tfc-org" {
  key             = "TFC_ORGANIZATION"
  value           = ""
  category        = "terraform"
  description     = "terraform organization"
  variable_set_id = tfe_variable_set.vault-ecs-demo-varset.id
}

//infrastructure Workspace
resource "tfe_workspace" "vault-agent-ecs-infra" {
  name                  = "vault-agent-ecs-infra"
  organization          = var.TFC_ORGANIZATION
  auto_apply            = true
  queue_all_runs        = true
  file_triggers_enabled = true
  project_id            = tfe_project.vault-ecs-demo-proj.id
  working_directory     = "infrastructure"
  vcs_repo {
    identifier     = "${var.github-user}/ecs-vault-demos"
    branch         = "master"
    oauth_token_id = tfe_oauth_client.github-oauth-client.oauth_token_id
  }

}

resource "tfe_workspace_variable_set" "vault-agent-ecs-infra" {
  workspace_id    = tfe_workspace.vault-agent-ecs-infra.id
  variable_set_id = tfe_variable_set.vault-ecs-demo-varset.id
}

//Vault configuration Workspace
resource "tfe_workspace" "vault-agent-ecs-vault" {
  name                  = "vault-agent-ecs-vault"
  organization          = var.TFC_ORGANIZATION
  auto_apply            = true
  queue_all_runs        = true
  file_triggers_enabled = true
  project_id            = tfe_project.vault-ecs-demo-proj.id
  working_directory     = "vault"
  vcs_repo {
    identifier     = "${var.github-user}/ecs-vault-demos"
    branch         = "master"
    oauth_token_id = tfe_oauth_client.github-oauth-client.oauth_token_id
  }

}

resource "tfe_workspace_variable_set" "vault-agent-ecs-vault" {
  workspace_id    = tfe_workspace.vault-agent-ecs-vault.id
  variable_set_id = tfe_variable_set.vault-ecs-demo-varset.id
}

//ECS Task Workspace
resource "tfe_workspace" "vault-agent-ecs-app" {
  name                  = "vault-agent-ecs-app"
  organization          = var.TFC_ORGANIZATION
  auto_apply            = true
  queue_all_runs        = true
  file_triggers_enabled = true
  project_id            = tfe_project.vault-ecs-demo-proj.id
  working_directory     = "application"
  vcs_repo {
    identifier     = "${var.github-user}/ecs-vault-demos"
    branch         = "master"
    oauth_token_id = tfe_oauth_client.github-oauth-client.oauth_token_id
  }

}

resource "tfe_workspace_variable_set" "vault-agent-ecs-app" {
  workspace_id    = tfe_workspace.vault-agent-ecs-app.id
  variable_set_id = tfe_variable_set.vault-ecs-demo-varset.id
}
