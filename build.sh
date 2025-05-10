#!/bin/bash

# QZ Tray Multi-Platform Build Script
# Usage: ./build.sh /path/to/certificate
# Set environment variables i.e. JAVA_HOME, ANT_HOME if needed, or assume java/ant is in PATH
# See: https://qz.io/docs/install-dependencies
# Build for Windows , macOS and Linux
# See: https://qz.io/docs/compiling

set -e

CERT_PATH="$1"

if [ -z "$CERT_PATH" ]; then
  echo "Usage: $0 /path/to/certificate"
  exit 1
fi

if [ ! -f "$CERT_PATH" ]; then
  echo "Error: Certificate file '$CERT_PATH' does not exist."
  exit 2
fi

echo "Certificate found: $CERT_PATH"

mkdir -p build

echo "Starting build for all platforms..."

INSTALLERS=(
  "nsis" # Windows installer
  "pkgbuild" # macOS installer
  "makeself" # Linux installer
)

for INSTALLER in "${INSTALLERS[@]}"; do

  echo "=== Building for $INSTALLER (arm64) ==="

  ant "$INSTALLER" -Dauthcert.use="$CERT_PATH" || { # arm64 is default
    echo "Build failed for $INSTALLER (arm64)";
    exit 3;
  }

  # Copy arm64 generated file
  GEN_FILE_ARM64=$(ls out/qz-tray-*-arm64.* 2>/dev/null | head -n 1)
  if [[ -n "$GEN_FILE_ARM64" ]]; then
    cp "$GEN_FILE_ARM64" "build/$(basename "$GEN_FILE_ARM64")"
    echo "Copied $GEN_FILE_ARM64 to build/$(basename "$GEN_FILE_ARM64")"
  else
    echo "No generated arm64 file found for $INSTALLER"
  fi

  echo "=== Building for $INSTALLER (x86_64) ==="

  ant "$INSTALLER" -Dauthcert.use="$CERT_PATH" -Dtarget.arch=x86_64 || {
    echo "Build failed for $INSTALLER (x86_64)";
    exit 3;
  }

  # Copy x86_64 generated file
  GEN_FILE_X64=$(ls out/qz-tray-*-x86_64.* 2>/dev/null | head -n 1)
  if [[ -n "$GEN_FILE_X64" ]]; then
    cp "$GEN_FILE_X64" "build/$(basename "$GEN_FILE_X64")"
    echo "Copied $GEN_FILE_X64 to build/$(basename "$GEN_FILE_X64")"
  else
    echo "No generated x86_64 file found for $INSTALLER"
  fi

done

echo "Build completed for all platforms. Output can be found in the 'build/' directory."
