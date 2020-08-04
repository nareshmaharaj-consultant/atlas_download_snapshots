URL=$1
AWS_BIN=/usr/local/bin/
echo "`date +%FT%H.%M.%S` - INFO - Uploading file: ${URL##*/} to S3 Bucket: ${ATLAS_BACKUP_DOWNLOADS_S3_BUCKET}" >> $ATLAS_BACKUP_DOWNLOADS_LOG
curl $URL 2>log.out | $AWS_BIN/aws s3 cp - s3://${ATLAS_BACKUP_DOWNLOADS_S3_BUCKET}/${URL##*/}
SIZE_FROM_S3=`$AWS_BIN/aws s3 ls s3://${ATLAS_BACKUP_DOWNLOADS_S3_BUCKET}/${URL##*/} | awk -F' {1,}' '{print $3}'`
if [[ $SIZE_FROM_S3 -gt 0 ]];then
    echo "`date +%FT%H.%M.%S` - INFO - S3 Upload Success for file: ${URL##*/}" >> $ATLAS_BACKUP_DOWNLOADS_LOG
else
    ERR_MSG="`date +%FT%H.%M.%S` - ERROR - S3 Upload for file: ${URL##*/} unconfirmed" 
    echo $ERR_MSG >> $ATLAS_BACKUP_DOWNLOADS_LOG
    curl -X POST -H 'Content-type: application/json' --data '{"text": "'"$ERR_MSG"'"}' $ATLAS_BACKUP_DOWNLOADS_SLACK_WEB_HOOK 2>/dev/null
fi
