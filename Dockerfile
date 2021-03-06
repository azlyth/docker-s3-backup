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

# Declare the needed AWS environment variables
ENV AWS_ACCESS_KEY_ID     aws-access-key-id
ENV AWS_SECRET_ACCESS_KEY aws-secret-access-key
ENV AWS_DEFAULT_REGION    aws-default-region


# Overlay this project's files onto the filesystem
ADD overlay /


# Run cron in the foreground
CMD ["crond", "-f", "-L", "8"]
