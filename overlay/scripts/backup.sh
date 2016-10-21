#!/bin/sh

TIMESTAMP=`date +%Y%m%d-%H%M%S`
BUCKETS=`ls /backups`

echo "Starting scheduled backup. (`date '+%D %T UTC'`)"

for BUCKET in $BUCKETS
do
  BACKUPS=`ls /backups/$BUCKET`
  BUCKET_TARBALL_DIR=/tmp/$BUCKET

  # Make a directory for the zipped backups
  mkdir $BUCKET_TARBALL_DIR

  # Make the backup tarballs
  for BACKUP in $BACKUPS
  do
    BACKUP_TARBALL_DIR=$BUCKET_TARBALL_DIR/$BACKUP
    BACKUP_TARBALL=$BACKUP-$TIMESTAMP.tar.bz2

    # Create the temp tarball directory and compress the files
    mkdir $BACKUP_TARBALL_DIR
    tar cvjf $BACKUP_TARBALL_DIR/$BACKUP_TARBALL -C /backups/$BUCKET $BACKUP > /dev/null
    echo "Tarred up '$BACKUP'."
  done

  # Upload the backups to S3
  aws s3 cp --recursive $BUCKET_TARBALL_DIR s3://$BUCKET/ > /dev/null
  echo "Uploaded tarballs to bucket '$BUCKET'."

  # Clean up the zipped files
  rm -rf $BUCKET_TARBALL_DIR
done

echo "Backups completed."
