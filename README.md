# ZFI005 Repository

This repository contains ABAP sources for the **EXT.FI.005 - Escritural de T\u00edtulos cancelados** scenario. The content was exported using [abapGit](https://abapgit.org/).

## Packages

- **ZFI005**: Main package using **ABAP Cloud**. All objects are stored in `src/`.
- **ZFI005_WRP**: Wrapper package with **Standard ABAP** artifacts located in `src/wrp/`.

## Development Model

The project follows a 3-tier approach:

1. **Persistence** \- CDS views and database definitions
2. **Business Logic** \- Classes and behavior implementations
3. **Presentation/API** \- Service definitions and other consumption artifacts

## Repository Layout

```
src/        Cloud ABAP objects
src/wrp/    Standard ABAP wrapper objects
```

## Usage

Clone this repository into an ABAP system using abapGit and activate the objects. For ABAP Cloud development use the `ZFI005` package. For any required classic development, use the `ZFI005_WRP` wrapper package.

