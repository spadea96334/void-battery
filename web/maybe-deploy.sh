#!/bin/bash
set -e

sh touch-versions.sh

remote_fingerprint="$(curl -s --fail https://void-battery.appspot.com/pob/fingerprint)"
echo fingerprints:
echo "remote: $remote_fingerprint"

local_fingerprint="$(cat nebuloch/data/fingerprint.txt)"
echo " local: $local_fingerprint"

remote_version="$(curl -s --fail https://void-battery.appspot.com/version)"
echo versions:
echo "remote: $remote_version"

local_version="$(cat version.txt)"
echo " local: $local_version"

if [[ "$remote_fingerprint" == "$local_fingerprint" && "$remote_version" == "$local_version" ]]
then
    echo "Fingerprint and version same, skip deployment"
else
    gcloud app deploy --version="$(git branch --show-current)"
fi
