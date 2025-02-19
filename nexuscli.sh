#!/bin/bash

echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/BidyutRoy2/BidyutRoy2/main/logo.sh | bash
echo "-----------------------------------------------------------------------------"

# Update and upgrade packages
sudo apt update && sudo apt upgrade -y

# Install necessary dependencies
sudo apt install -y curl git build-essential pkg-config libssl-dev unzip

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

# Install Protocol Buffers (Protobuf)
wget https://github.com/protocolbuffers/protobuf/releases/download/v21.12/protoc-21.12-linux-x86_64.zip
unzip protoc-21.12-linux-x86_64.zip -d $HOME/.local
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Install protobuf codegen
cargo install protobuf-codegen

# Add target and component for Rust
rustup target add riscv32i-unknown-none-elf
rustup component add rust-src

# Create directory for Nexus and clone repository
mkdir -p $HOME/.nexus
cd $HOME/.nexus
git clone https://github.com/nexus-xyz/network-api
cd network-api

# Checkout the latest version/tag
git fetch --tags
git checkout $(git rev-list --tags --max-count=1)

# Build the project
cd clients/cli
cargo clean
cargo build --release

# Run the project
cargo run --release -- --start --beta
