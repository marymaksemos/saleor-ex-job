output "provider_id" {
  value = google_iam_workload_identity_pool_provider.github_identity.name
}

output "service_account" {
  value = google_service_account.github_identity
}
