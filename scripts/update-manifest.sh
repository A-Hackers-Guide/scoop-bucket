#!/bin/sh
# Regenerates bucket/sys1.json for the latest (or given) sys1 release from
# the SHA-256 checksums GoReleaser publishes with every release.
set -eu
REPO=A-Hackers-Guide/sys1
tag=${1:-}
if [ -z "$tag" ]; then
  tag=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -1)
fi
[ -n "$tag" ] || { echo "no release found" >&2; exit 1; }
v=${tag#v}
sums=$(curl -fsSL "https://github.com/$REPO/releases/download/$tag/checksums.txt")
sha() {
  s=$(printf '%s\n' "$sums" | awk -v f="sys1_${v}_windows_$1.zip" '$2 == f { print $1 }')
  [ -n "$s" ] || { echo "missing checksum for windows_$1" >&2; exit 1; }
  printf '%s' "$s"
}
base="https://github.com/$REPO/releases/download"
cat > "$(dirname "$0")/../bucket/sys1.json" <<JSON
{
    "version": "$v",
    "description": "Pool the spare power of every computer into one cloud. Installs sys0 (client) and sys1 (node).",
    "homepage": "https://a-hackers-guide.github.io/sys1/",
    "license": "Unlicense",
    "architecture": {
        "64bit": {
            "url": "$base/$tag/sys1_${v}_windows_amd64.zip",
            "hash": "$(sha amd64)"
        },
        "arm64": {
            "url": "$base/$tag/sys1_${v}_windows_arm64.zip",
            "hash": "$(sha arm64)"
        }
    },
    "bin": ["sys0.exe", "sys1.exe"],
    "notes": [
        "Lend this PC to a pool:  sys0   (run as Administrator to install the background service)",
        "Run a node here:         sys1"
    ],
    "checkver": {
        "github": "https://github.com/$REPO"
    },
    "autoupdate": {
        "architecture": {
            "64bit": { "url": "$base/v\$version/sys1_\$version_windows_amd64.zip" },
            "arm64": { "url": "$base/v\$version/sys1_\$version_windows_arm64.zip" }
        },
        "hash": { "url": "\$baseurl/checksums.txt" }
    }
}
JSON
echo "bucket/sys1.json -> $tag"
