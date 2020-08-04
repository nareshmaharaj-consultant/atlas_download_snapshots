AWS_BIN=/usr/local/bin/
FILE=restore-${1}.tar.gz
echo "`date +%FT%H.%M.%S` - INFO - Checking if the file ${FILE} already exists in S3 Bucket: ${ATLAS_BACKUP_DOWNLOADS_S3_BUCKET}" >> $ATLAS_BACKUP_DOWNLOADS_LOG
#echo $FILE
SIZE_FROM_S3=`$AWS_BIN/aws s3 ls s3://${ATLAS_BACKUP_DOWNLOADS_S3_BUCKET}/${FILE##*/}| awk -F' {1,}' '{print $3}'`
if [[ $SIZE_FROM_S3 -gt 0 ]];then
	echo "`date +%FT%H.%M.%S` - INFO - Ignore ${FILE} as it exists in S3 Bucket: ${ATLAS_BACKUP_DOWNLOADS_S3_BUCKET}, size: ${SIZE_FROM_S3} bytes" >> $ATLAS_BACKUP_DOWNLOADS_LOG
else
	echo "`date +%FT%H.%M.%S` - INFO - Will begin to create snapshot ${FILE} to S3 Bucket: ${ATLAS_BACKUP_DOWNLOADS_S3_BUCKET}" >> $ATLAS_BACKUP_DOWNLOADS_LOG
	echo ${1}
fi
