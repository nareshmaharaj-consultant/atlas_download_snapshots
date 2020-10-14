touch `echo ${ATLAS_BACKUP_DOWNLOADS_LOG}`

rm -f *snapshotUrls.txt
touch "`date +%FT%H.%M.%S`-snapshotUrls.txt"

rm -f *deliveryUrls.txt
touch "`date +%FT%H.%M.%S`-deliveryUrls.txt"

echo "`date +%FT%H.%M.%S` - INFO - Getting a list of the snapshots for Atlas group: $ATLAS_BACKUP_DOWNLOADS_GROUP and cluster: $ATLAS_BACKUP_DOWNLOADS_CLUSTER" >> $ATLAS_BACKUP_DOWNLOADS_LOG

curl --user $ATLAS_BACKUP_DOWNLOADS_USER --digest --include \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  --request GET "https://cloud.mongodb.com/api/atlas/v1.0/groups/$ATLAS_BACKUP_DOWNLOADS_GROUP/clusters/$ATLAS_BACKUP_DOWNLOADS_CLUSTER/backup/snapshots/?pretty=true" \
2>/dev/null | tail -n +15 | jq '.results[0] | if (.snapshotIds | length) != 0 then .snapshotIds[] else "List of snapshotIds not present. Check if Sharded. This config is for Sharded environment only" end' | while read line ; do echo $line ; done
