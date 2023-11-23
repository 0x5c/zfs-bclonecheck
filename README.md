# zfs-bclonecheck
Small script to check for bcloned files on a ZFS pool

> [!WARNING]
> This script requires a version of zdb that can dump the BRT. See https://github.com/openzfs/zfs/pull/15541

## Usage

```
bclonecheck.sh [-C] ZPOOL
```

Dumps the list of files that have been bcloned. Both the original and copy will be in the list.

Add `-C` to prevent removal of the created temporary directory, and print its path. Can be useful to see the list of DVAs affected.

