# A-Hackers-Guide Scoop bucket

[Scoop](https://scoop.sh) manifests for [sys1](https://github.com/A-Hackers-Guide/sys1), which pools the spare power of every computer into one cloud.

```powershell
scoop bucket add a-hackers-guide https://github.com/A-Hackers-Guide/scoop-bucket
scoop install a-hackers-guide/sys1
```

This installs both apps: `sys0` (the client that lends this PC's spare power to a pool) and `sys1` (the node and its dashboard). x64 and ARM64.

## How this bucket stays current

[`scripts/update-manifest.sh`](scripts/update-manifest.sh) writes `bucket/sys1.json` from the SHA-256 checksums published with each sys1 release. A [workflow](.github/workflows/update.yml) runs it every hour, commits any change, then installs and runs sys1 with real Scoop on Windows. The manifest also has `checkver`/`autoupdate`, so Scoop's own tools can update it.

Problems? Open an issue in the [main repository](https://github.com/A-Hackers-Guide/sys1/issues).
