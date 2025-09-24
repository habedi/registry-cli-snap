#!/bin/bash

# Directory containing versioned Snapcraft files
SNAPCRAFT_FILES_DIR="releases"

# Function to compare semantic versions and find the highest
get_highest_version() {
    # Find directories matching the pattern "vX.X.X" and extract valid semantic versions
    versions=$(ls -d ${SNAPCRAFT_FILES_DIR}/v* 2>/dev/null | grep -Eo 'v[0-9]+\.[0-9]+\.[0-9]+' | sort -V)

    # If no valid versions are found, exit with an error
    if [[ -z "$versions" ]]; then
        echo "Error: No valid semantic version directories found in '$SNAPCRAFT_FILES_DIR'."
        exit 1
    fi

    # Return the highest version
    echo "$versions" | tail -n 1
}

# Get the highest version
FOLDER_NAME=$(get_highest_version)
if [[ $? -ne 0 ]]; then
    exit 1
fi

# Remove the 'v' prefix to get the version number
VERSION="${FOLDER_NAME#v}"
echo "Detected highest version: $VERSION"

# Always prepare the snap/snapcraft.yaml from the latest release folder
prepare_snapcraft() {
    echo "Preparing Snapcraft files for version $VERSION..."
    mkdir -p snap
    cp -f "$SNAPCRAFT_FILES_DIR/$FOLDER_NAME/snapcraft.yaml" snap/snapcraft.yaml

    # Use sed to update the version in the copied snapcraft.yaml
    echo "Updating version in snap/snapcraft.yaml to $VERSION..."
    sed -i "s/version: .*/version: '$VERSION'/" snap/snapcraft.yaml

    echo "Snapcraft.yaml prepared in the 'snap' directory."
}

# Handle the `--just-prepare` argument
if [[ "$1" == "--just-prepare" ]]; then
    prepare_snapcraft
    exit 0
fi

# Prepare before building
prepare_snapcraft

# Build mode selection
case "$1" in
  --remote-build)
    echo "Performing remote build for architectures defined in snap/snapcraft.yaml (e.g., amd64, arm64)..."
    # Accept public upload to Launchpad builders to avoid interactive prompt
    snapcraft remote-build --launchpad-accept-public-upload
    BUILD_STATUS=$?
    ;;
  ""|--local)
    echo "Building Snap package locally (default) using Multipass..."
    SNAPCRAFT_BUILD_ENVIRONMENT=multipass snapcraft pack
    BUILD_STATUS=$?
    ;;
  *)
    echo "Unknown argument: $1"
    echo "Usage: $0 [--just-prepare | --remote-build | --local]"
    exit 2
    ;;
esac

if [[ $BUILD_STATUS -eq 0 ]]; then
    echo "Build successful. Available snap files:"
    ls -lh ./*.snap 2>/dev/null || echo "No snaps found. If using remote-build, they will be downloaded when jobs finish."
else
    echo "Error: Snap build failed."
    exit 1
fi

echo "Snap package build process completed."
