source /etc/profile.d/atlas_download_snapshot.sh
$ATLAS_BACKUP_DOWNLOADS_HOME/./_getListBackupSnapshots.sh | sed 's/"//g' | while read line ; do $ATLAS_BACKUP_DOWNLOADS_HOME/_createSnapshotJob.sh $line;done | sed 's/"//g' | while read line ; do $ATLAS_BACKUP_DOWNLOADS_HOME/_downloadSnapshotJob.sh $line;done | sed 's/"//g' | while read line ; do $ATLAS_BACKUP_DOWNLOADS_HOME/_uploadBackupSnapshotAWS_S3.sh $line;done