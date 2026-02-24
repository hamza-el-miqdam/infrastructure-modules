# Zenika Terraform Modules

Welcome to the central repository for Zenika's Terraform modules!

This repository houses a collection of generic, highly reusable, and opinionated Terraform modules designed to provision infrastructure securely and consistently across all our projects.

# Repository Architecture

We have adopted a monorepo approach that blends HashiCorp's Terraform best practices:

```
└── terraform_modules
    ├── aws
    │   ├── aws_config
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   ├── providers.tf
    │   │   ├── README.md
    │   │   ├── role.tf
    │   │   └── variables.tf
    │   └── security_hub
    │       ├── main.tf
    │       ├── providers.tf
    │       ├── README.md
    │       └── variables.tf
    ├── azure
    └── gcp
```

- Cloud Namespacing (terraform_modules/): Modules are strictly isolated by their cloud provider to maintain a clean boundary between different vendor APIs and configurations.

- Flat Module Design: Inside each cloud provider directory, individual services (like aws_config or security_hub) are kept flat and atomic. We avoid complex, deeply nested dependency chains between modules to keep them predictable and easy to consume.
