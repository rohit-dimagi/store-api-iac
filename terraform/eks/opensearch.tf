module "opensearch" {
  source                                         = "cyberlabrs/opensearch/aws"
  name                                           = "demo"
  engine_version                                 = "OpenSearch_1.3"
  region                                         = var.region
  advanced_security_options_enabled              = false
  default_policy_for_fine_grained_access_control = false
  internal_user_database_enabled                 = true
  node_to_node_encryption                        = true
  encrypt_at_rest = {
    enabled = true
  }
}
