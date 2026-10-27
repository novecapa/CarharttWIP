#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

# CI and local runs use the same shared scheme. A caller can select a specific device.
if [[ -z "${SIMULATOR_UDID:-}" ]]; then
  SIMULATOR_UDID=$(xcrun simctl list devices available -j | python3 -c '
import json, sys
runtimes = json.load(sys.stdin)["devices"]
def version(runtime):
    return tuple(int(part) for part in runtime.split("iOS-")[-1].split("-"))
for runtime in sorted((r for r in runtimes if "iOS-" in r), key=version, reverse=True):
    if version(runtime) < (17, 2):
        continue
    for device in runtimes[runtime]:
        if device["isAvailable"] and device["name"].startswith("iPhone"):
            print(device["udid"])
            sys.exit(0)
sys.exit("No available iPhone simulator with iOS 17.2 or newer")
')
fi

xcodebuild test \
  -project CarharttWIP.xcodeproj \
  -scheme CarharttWIP \
  -destination "platform=iOS Simulator,id=$SIMULATOR_UDID" \
  -parallel-testing-enabled NO \
  -enableCodeCoverage YES \
  -derivedDataPath "${DERIVED_DATA_PATH:-.build/DerivedData}" \
  -resultBundlePath "${RESULT_BUNDLE_PATH:-.build/TestResults-$(date +%Y%m%d-%H%M%S).xcresult}" \
  CODE_SIGNING_ALLOWED=NO \
  "$@"
