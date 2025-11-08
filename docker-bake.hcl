variable "JIRA_VERSION" {
  default = "latest"
}

variable "CONFLUENCE_VERSION" {
  default = "latest"
}

variable "REGISTRY" {
  default = "harbor.nobidev.tech"
}

target "krakatau" {
  context = "krakatau"
  pull = true
  tags = [
    "${REGISTRY}/library/krakatau:latest"
  ]
}

target "jira" {
  context = "jira"
  pull = true
  contexts = {
    krakatau: "target:krakatau"
  }
  args = {
    VERSION: "${JIRA_VERSION}"
  }
  tags = [
    "${REGISTRY}/atlassian/jira:${JIRA_VERSION}"
  ]
  output = [
    "type=registry,push=true"
  ]
}

target "confluence" {
  context = "confluence"
  pull = true
  contexts = {
    krakatau: "target:krakatau"
  }
  args = {
    VERSION: "${CONFLUENCE_VERSION}"
  }
  tags = [
    "${REGISTRY}/atlassian/confluence:${CONFLUENCE_VERSION}"
  ]
  output = [
    "type=registry,push=true"
  ]
}

group "default" {
  targets = [
    "krakatau",
    "jira",
    "confluence",
  ]
}
