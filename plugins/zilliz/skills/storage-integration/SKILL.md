---
name: storage-integration
description: Use when the user wants to connect Zilliz Cloud to their own AWS S3, Azure Blob, or GCS bucket -- generating the IAM/trust policy to grant, validating access, or creating, listing, describing, or deleting a storage integration.
---

## Prerequisites

1. CLI installed and logged in (see setup skill).
2. Access to the user's cloud account to grant Zilliz Cloud permissions on the bucket.

## Commands Reference

### List Storage Integrations

```bash
zilliz storage-integration list
# Optional: --project-id <filter-by-project-id>
# Pagination: --page-size <n> --page <n>
# Fetch all pages: --all
```

### Create a Storage Integration

```bash
zilliz storage-integration create --name <integration-name> --bucket-name <external-bucket-name>
# Optional:
#   --project-id <owning-project-id>
#   --description <integration-description>
#   --region-id <cloud-region>
#   --role-arn <aws-iam-role-arn>
#   --external-id <aws-external-id>
#   --account-name <azure-storage-account-name>
#   --client-id <azure-client-id>
#   --tenant-id <azure-tenant-id>
#   --gcp-project-id <gcp-project-id>
#   --service-account-email <gcp-service-account-email>
# Or use raw JSON: --body '{...}'
```

### Describe a Storage Integration

```bash
zilliz storage-integration describe --integration-id <storage-integration-id>
```

### Delete a Storage Integration

```bash
zilliz storage-integration delete --integration-id <storage-integration-id>
```

### Validate a storage integration configuration

```bash
zilliz storage-integration validate --bucket-name <external-bucket-name>
# Optional:
#   --project-id <project-id>
#   --region-id <cloud-region>
#   --role-arn <aws-iam-role-arn>
#   --external-id <aws-external-id>
#   --account-name <azure-storage-account-name>
#   --client-id <azure-client-id>
#   --tenant-id <azure-tenant-id>
#   --gcp-project-id <gcp-project-id>
#   --service-account-email <gcp-service-account-email>
# Or use raw JSON: --body '{...}'
```

### Generate storage integration authorization materials

```bash
zilliz storage-integration generate-auth-materials --bucket-name <external-bucket-name>
# Optional: --project-id <project-id>, --region-id <cloud-region>
# Or use raw JSON: --body '{...}'
```

## Setup Flow

Connecting a bucket is a three-step flow. Do the steps in order:

1. **Generate authorization materials** for the bucket and region:

   ```bash
   zilliz storage-integration generate-auth-materials \
     --bucket-name <bucket> --region-id <region-id> -o json
   ```

   The response holds what the user must grant in their own cloud account:
   for AWS an IAM policy (`iamPolicy`), a trust policy (`trustPolicy`), the
   Zilliz Cloud account to trust (`zillizAccount`) and an `externalId`; for GCP
   the service account to grant (`googleCloudServiceAccount`); for Azure the
   credential material (`credential`).

2. **Grant access** in the user's cloud console or IaC using those materials.
   This happens outside the CLI.

3. **Validate, then create** with the same credential flags:

   - AWS: `--role-arn` and `--external-id`
   - Azure: `--account-name`, `--client-id`, and `--tenant-id`
   - GCP: `--gcp-project-id` and `--service-account-email`

   Run `validate` first; it checks access without saving anything. Then run
   `create` with the same flags plus `--name`.

## Guidance

- Pass the credential flags for one cloud only, and make them match `--region-id` (e.g. `aws-*` with `--role-arn`).
- If `validate` fails, the grant from step 2 is usually missing or still propagating. Re-check the policy before retrying; do not create the integration anyway.
- The CLI redacts `--external-id` from local command history. Still avoid repeating it in replies.
- Before deleting an integration, confirm with the user. Anything that reads the bucket through it loses access.
