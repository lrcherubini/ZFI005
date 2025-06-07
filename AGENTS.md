# Repository Guidelines

This repository contains ABAP Cloud code and a wrapper for Standard ABAP. Keep Cloud artifacts under `src/` and Standard ABAP objects under `src/wrp/`.

## Development

- Follow a 3-tier architecture: persistence, business logic, and presentation/API layers.
- Use ABAP Cloud syntax in the `ZFI005` package.
- Use the `ZFI005_WRP` package only for classic ABAP functionality not available in the cloud.

## Pull Requests

- Provide a short summary of your changes.
- If tests are available, run them and include the results in the PR description. This repository currently has no automated test suite.

