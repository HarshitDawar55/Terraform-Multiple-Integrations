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


