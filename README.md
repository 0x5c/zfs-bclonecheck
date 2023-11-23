# zfs-bclonecheck
Small script to check for bcloned files on a ZFS pool

> [!IMPORTANT]
> This script requires a version of zdb that can dump the BRT. See https://github.com/openzfs/zfs/pull/15541

> [!WARNING]
> This script (and zfs as a whole) can only report bcloned files that still have at least two instances (original+copy, two or more copies, ...).  
> Files were only one instance or less exists could have been bcloned at some point in the past and not be reported.

> [!NOTE]
> If you use this script to identify files potentially affected by https://github.com/openzfs/zfs/issues/15526, be aware that the bug has since been reproduced on both 2.2.1 (where bclone is default-disabled) and 2.1.x where bclone did not exist; it seems the corruption bug was preëxisting and only made easier to hit by bclone.

## Usage

```
bclonecheck.sh [-C] ZPOOL
```

Dumps the list of files that have been bcloned. Both the original and copy will be in the list.

Add `-C` to prevent removal of the created temporary directory, and print its path. Can be useful to see the list of DVAs affected.

