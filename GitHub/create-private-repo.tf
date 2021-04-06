terraform {
  required_providers {
      github = {
          source = "integrations/github"
          version = "4.6.0"
      }
  }
}

provider "github" {
  token = "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"
}


resource "github_repository" "Repo_From_Terraform" {
  name = "Repo_From_Terraform"
  description = "This Repository is a test Repository from Terraform!"
}

output "GitHub_Repo_Output" {
  value = github_repository.Repo_From_Terraform
}