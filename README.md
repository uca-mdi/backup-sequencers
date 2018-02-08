# backup-sequencers

remove --dry-run

Utility to save data from servers to the NAS.

## Pre-requisites
* NAS mounted and accessible (e.g., cifs)
* The `WHO` variable must be set in `backup.sh`

## What it does
Synchronize the `/results` folder from the server to the NAS.

Synchronize the `/plugins` folder from the server to the NAS.

Save `.fastq`, `.bam` and `.vcf` files on the `${WHO}/archive` folder on the NAS, along with the information
on the plugin version (date).

## Notes

The `-a` option of `rsync` does not work, as `root` is used to write on the NAS.
Ownership, groups and permissions on files are not saved for the very same reason.