FROM alpine:3.4
MAINTAINER Peter Valdez <peter@ptrvldz.me>

# Update and upgrade Alpine system packages
RUN apk update
RUN apk upgrade


# Install python and pip
RUN apk add python py-pip

# Install AWS CLI dependencies
RUN apk add groff less

# Install AWS CLI
RUN pip install awscli


# Install packages needed for making backups
RUN apk add zip

# Add the backup script
ADD scripts /scripts


VOLUME /backups

CMD sh /scripts/backup.sh
