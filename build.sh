#!/usr/bin/env bash
# ==============================================================================
# POX LOGS DUMPER (Build & Packaging Script)
# Generates a flashable zip package compatible with TWRP, OrangeFox, PBRP, etc.
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

VERSION="${VERSION:-2.0}"
OUT_DIR="out"
ZIP_NAME="poxlogsdumper.zip"
VERSIONED_ZIP="poxlogsdumper-v${VERSION}.zip"

echo "==> Preparing build environment..."
mkdir -p "${OUT_DIR}"

echo "==> Setting executable permissions..."
chmod +x META-INF/com/google/android/update-binary
chmod +x tools/poxzip_arm tools/poxzip_arm64
chmod +x poxlogsdumper.sh

echo "==> Packaging ${ZIP_NAME}..."
rm -f "${OUT_DIR}/${ZIP_NAME}" "${OUT_DIR}/${VERSIONED_ZIP}"
zip -r9 -X "${OUT_DIR}/${ZIP_NAME}" \
  META-INF \
  tools \
  poxlogsdumper.sh \
  README.md

echo "==> Creating versioned artifact: ${VERSIONED_ZIP}..."
cp "${OUT_DIR}/${ZIP_NAME}" "${OUT_DIR}/${VERSIONED_ZIP}"

echo "==> Generating SHA256 checksums..."
(cd "${OUT_DIR}" && sha256sum "${ZIP_NAME}" > "${ZIP_NAME}.sha256")
(cd "${OUT_DIR}" && sha256sum "${VERSIONED_ZIP}" > "${VERSIONED_ZIP}.sha256")

echo "==> Build completed successfully!"
echo "    Archive:   ${OUT_DIR}/${ZIP_NAME}"
echo "    Versioned: ${OUT_DIR}/${VERSIONED_ZIP}"
echo "    SHA256:    $(awk '{print $1}' "${OUT_DIR}/${ZIP_NAME}.sha256")"
