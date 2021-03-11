#!/bin/sh
set -eo pipefail

gpg --quiet --batch --yes --decrypt --passphrase="break-this" --output ./.github/secrets/BTDemo_Base_SDK__App_Store.mobileprovision ./.github/secrets/BTDemo_Base_SDK__App_Store.mobileprovision.gpg
gpg --quiet --batch --yes --decrypt --passphrase="break-this" --output ./.github/secrets/apple_distribution_key.p12 ./.github/secrets/apple_distribution_key.p12.gpg

mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles

cp ./.github/secrets/BTDemo_Base_SDK__App_Store.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/BTDemo_Base_SDK__App_Store.mobileprovision


security create-keychain -p "" build.keychain
security import ./.github/secrets/apple_distribution_key.p12 -t agg -k ~/Library/Keychains/build.keychain -P "" -A

security list-keychains -s ~/Library/Keychains/build.keychain
security default-keychain -s ~/Library/Keychains/build.keychain
security unlock-keychain -p "" ~/Library/Keychains/build.keychain

security set-key-partition-list -S apple-tool:,apple: -s -k "" ~/Library/Keychains/build.keychain
