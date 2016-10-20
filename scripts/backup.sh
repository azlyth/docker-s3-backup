#!/bin/sh

TIMESTAMP=`date +%Y%m%d-%H%M%S`
BUCKETS=`ls /backups`

for BUCKET in $BUCKETS
do
  BACKUPS=`ls /backups/$BUCKET`
  ZIPPED_BUCKET_DIR=/tmp/$BUCKET

  # Make a directory for the zipped backups
  mkdir $ZIPPED_BUCKET_DIR

  # Zip up the backups
  for BACKUP in $BACKUPS
  do
    ZIPPED_BACKUP_DIR=$ZIPPED_BUCKET_DIR/$BACKUP

    # Create the zipped backup directory and zip up the files
    mkdir $ZIPPED_BACKUP_DIR
    zip -r9 $ZIPPED_BACKUP_DIR/$BACKUP-$TIMESTAMP.zip /backups/$BUCKET/$BACKUP > /dev/null
  done

  # Upload the backups to S3
  find /tmp
done
