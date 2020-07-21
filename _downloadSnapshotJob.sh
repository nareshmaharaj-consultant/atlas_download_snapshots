echo "`date +%FT%H.%M.%S` - INFO - Creating the Download Gunzip (gz) file for snapshot restore-job: $1" >> $ATLAS_BACKUP_DOWNLOADS_LOG
SLEEPTIME=1m
OUTFILE=`ls -1rt | grep deliveryUrls | tail -n 1`
if [[ -z $1 || $1 == "null" ]];then
	ERR_MSG="`date +%FT%H.%M.%S` - ERROR - Restore job received is $1 and not valid - no point to continue"
	echo $ERR_MSG >> $ATLAS_BACKUP_DOWNLOADS_LOG
	if [[ ! -z $ATLAS_BACKUP_DOWNLOADS_SLACK_WEB_HOOK ]]; then
    		ERR_MSG="`date +%FT%H.%M.%S` - ERROR - Restore job received is $1 and not valid - no point to continue"
    		curl -X POST -H 'Content-type: application/json' --data '{"text": "'"$ERR_MSG"'"}' $ATLAS_BACKUP_DOWNLOADS_SLACK_WEB_HOOK 2>/dev/null
	fi
	exit
fi
while true;do
	DOWNLOAD_FILE=$(curl --user $ATLAS_BACKUP_DOWNLOADS_USER --digest --include \
     	--header "Accept: application/json" \
     	--header "Content-Type: application/json" \
     	--request GET "$1/?pretty=true" \
	2>/dev/null | tail -n +14  | jq '.deliveryUrl[]')
	if [[ $DOWNLOAD_FILE =~ ".tar.gz" ]];then
		break
	else
		echo "`date +%FT%H.%M.%S` - INFO - Download snapshot file not ready - sleeping for $SLEEPTIME mins" >> $ATLAS_BACKUP_DOWNLOADS_LOG
		sleep $SLEEPTIME
	fi
done
echo $DOWNLOAD_FILE | tee -a $OUTFILE
