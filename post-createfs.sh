#!/bin/sh

set -e

FWUP_CONFIG=$NERVES_DEFCONFIG_DIR/fwup.conf

# Buildroot creates the removable-media UEFI binary during image generation,
# so wire our custom GRUB config and expose bootx64.efi to fwup here.
mkdir -p "$BINARIES_DIR/efi-part/EFI/BOOT"
cp -f "$NERVES_DEFCONFIG_DIR/grub.cfg" "$BINARIES_DIR/efi-part/EFI/BOOT/grub.cfg"
cp -f "$BINARIES_DIR/efi-part/EFI/BOOT/bootx64.efi" "$BINARIES_DIR/bootx64.efi"

# Run the common post-image processing for nerves
$BR2_EXTERNAL_NERVES_PATH/board/nerves-common/post-createfs.sh $TARGET_DIR $FWUP_CONFIG
