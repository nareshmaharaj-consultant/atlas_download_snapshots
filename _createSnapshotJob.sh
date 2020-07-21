echo "`date +%FT%H.%M.%S` - INFO - Creating restore-job from snapshotId $1" >> $ATLAS_BACKUP_DOWNLOADS_LOG
OUTFILE=`ls -1rt | grep snapshotUrls | tail -n 1`
SNAPSHOT_PAYLOAD="{\"snapshotId\" : \"$1\", \"deliveryType\" : \"download\"}"
echo "`date +%FT%H.%M.%S` - INFO - Sending restore-job with payload: $SNAPSHOT_PAYLOAD" >> $ATLAS_BACKUP_DOWNLOADS_LOG
JOB=$(curl --user $ATLAS_BACKUP_DOWNLOADS_USER --digest --include \
     --header "Accept: application/json" \
     --header "Content-Type: application/json" \
     --request POST "https://cloud.mongodb.com/api/atlas/v1.0/groups/$ATLAS_BACKUP_DOWNLOADS_GROUP/clusters/$ATLAS_BACKUP_DOWNLOADS_CLUSTER/backup/restoreJobs/?pretty=true" \
     --data "$SNAPSHOT_PAYLOAD" \
2>/dev/null | tail -n +14  | jq '.links[0].href')
echo "`date +%FT%H.%M.%S` - INFO - Received restore-job: $JOB" >> $ATLAS_BACKUP_DOWNLOADS_LOG
echo $JOB | tee -a $OUTFILE
#2>/dev/null
