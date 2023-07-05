#!/usr/bin/env bash -e
# Grab latest certbot package from Lambda Python runtime image to ensure compatibility

REPO=$(pwd)
DOCKER_CMD="docker buildx build --platform linux/amd64 --tag certbot --no-cache --progress plain ${REPO}"
echo "Running ${DOCKER_CMD}"
ZIP_PATH=$(${DOCKER_CMD} 2>&1 | grep "Zip file created in" | grep -v "echo" | cut -d " " -f 7)
ZIP_FILE=$(basename ${ZIP_PATH})
CERTBOT_PATH="lib/${ZIP_FILE}"

docker run --rm --entrypoint cat certbot ${ZIP_PATH} > ${CERTBOT_PATH}
echo "Updated certbot package at ${CERTBOT_PATH}"

sed -i '' -e "s/lib\/certbot-[0-9]\.[0-9]\.[0-9]\.zip/lib\/${ZIP_FILE}/g" Makefile
echo "Updated Makefile to use ${CERTBOT_PATH}"