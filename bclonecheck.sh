#!/bin/sh

if [ "$1" = "-C" ]; then
    NOCLEAN=1
    shift
fi

errmsg() {
    printf '\033[91m%s\033[0m\n' "$1"
    exit 1
}

cleanup() {
    if [ -z "$NOCLEAN" ]; then
        rm -r "$tempdir"
    else
        printf "\nTemporary directory: %s\n" "$tempdir"
    fi

}

[ -n "$1" ] || errmsg "You must give a pool name!"
zpool="$1"

# Check the pool exists
zpool status "$zpool" > /dev/null 2>&1 || errmsg "Invalid pool name: $zpool"

# Check that zdb is capable of dumping the BRT
zdb -h 2>&1 | grep -q -- '-T --brt-stats' || \
    errmsg "Your version of zdb must have the -T/--brt-stats option!"

# Must be root!
[ "$(id -u)" -ne 0 ] && errmsg "$0: must be run as root!"

tempdir="$(mktemp -d)"

trap cleanup INT TERM
set -e

# Dump the BRT, write DVAs to file
# TODO: Can DVAs start with hex digits? how many digits?
zdb -TTT "$zpool" | grep -Po '^[0-9a-f]+:[0-9a-f]+(?=\s)' > "${tempdir}/dvas.txt"

# Dump pool blocks, filter for L0 blocks and match on dumped DVAs, get filepath for each
zdb -bbb -vvv "$zpool" | grep 'level 0' | grep -wf "${tempdir}/dvas.txt" | \
    cut -d' ' -f2,4 | xargs -n2 zfs_ids_to_path -v "$zpool" | column -ts: -N DATASET,PATH -l2

cleanup
