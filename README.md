# SuiandNix

A Nix flake containing integrations for Sui and Walrus CLI tools.

## Features

- **Sui CLI**: Nix package for the Sui blockchain CLI tool
- **Walrus CLI**: Nix package for the Walrus decentralized storage CLI tool

## Usage

This flake provides Nix packages for:
- `sui-cli`: The official Sui blockchain command-line interface
- `walrus-cli`: The Walrus decentralized storage command-line interface

## Installation

You can use this flake in your Nix configuration or run the tools directly:

```bash
# Run sui-cli
nix run github:Angleito/SuiandNix#sui-cli

# Run walrus-cli  
nix run github:Angleito/SuiandNix#walrus-cli
```

## Development

The packages are defined in the `pkgs/` directory:
- `pkgs/sui-cli/default.nix`: Sui CLI package definition
- `pkgs/walrus-cli/default.nix`: Walrus CLI package definition
