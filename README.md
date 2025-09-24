## A Snap Package for MCP Registry CLI

[![Publish](https://github.com/habedi/registry-cli-snap/actions/workflows/build_and_publish.yml/badge.svg)](https://github.com/habedi/registry-cli-snap/actions/workflows/build_and_publish.yml)
[![Snapcraft.io](https://snapcraft.io/mcp-publisher/badge.svg)](https://snapcraft.io/mcp-publisher)
[![License](https://img.shields.io/badge/License-MIT-yellow)](https://github.com/habedi/registry-cli-snap/blob/main/LICENSE)

This repository contains the code for building a Snap package from the latest
release of [MCP Registry CLI](https://github.com/modelcontextprotocol/registry/releases).

It's made to make it easier to install the `mcp-publisher` binary on different GNU/Linux distributions like Debian and
Ubuntu, and to keep it up-to-date.

> [!NOTE]
> The package is built for AMD64 and ARM64 architectures, and
> it includes the `mcp-publisher` binary, not the MCP Registry server.

### Installation

```bash
# Install the Snap package from the Snap Store
sudo snap install mcp-publisher --stable
```

### Development

```bash
# Install Snap, Snapcraft, and Multipass
sudo apt install snapd
sudo snap install snapcraft --classic
sudo snap install multipass --classic
```

```bash
# Clone this repository
git clone --depth=1 https://github.com/habedi/registry-cli-snap.git
```

```bash
# Build the package (choose one):
cd registry-cli-snap/

# 1) Remote build for AMD64 and ARM64 via Launchpad public builders (might take a while)
bash build.sh --remote-build

# 2) Local build using Multipass (only supports host architecture)
bash build.sh --local
```

```bash
# Install the package manually (optional)
sudo snap install --dangerous mcp-publisher_VER_ARCH.snap # Replace VER and ARCH with actual values
```

### License

This project is licensed under the MIT License (see [LICENSE](LICENSE)).
