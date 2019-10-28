#!/bin/bash

BASE_VERSION=latest

APP_NAME=sonarqube-custom
APP_NS=openshift

set -e

echo "---------------------------------------------------------------------------------"
echo "- delete all (bc, is)-"
echo "---------------------------------------------------------------------------------"
oc -n ${APP_NS} delete all -l app=${APP_NAME} --ignore-not-found=true

# oc -n cicd-tools delete all -l app=sonarqube --ignore-not-found=true

echo "---------------------------------------------------------------------------------"
echo "- new-build-"
echo "---------------------------------------------------------------------------------"
# cat Dockerfile | oc  -n ${APP_NS} new-build --name=${APP_NAME} --dockerfile='-'  --labels="app=${APP_NAME}"

oc -n ${APP_NS} new-build --name=${APP_NAME} \
  --strategy="docker" --labels="app=${APP_NAME}" --binary 

# oc -n ${APP_NS} new-build --name=${APP_NAME} \
  # --image-stream=${KIND_IMAGE_BASE}:${BASE_VERSION} \
  # --binary --labels="app=${APP_NAME}"

echo "---------------------------------------------------------------------------------"
echo "- start-build-"
echo "---------------------------------------------------------------------------------"
oc -n ${APP_NS} start-build ${APP_NAME} --from-dir=. --wait

echo "---------------------------------------------------------------------------------"
echo "- get is-"
echo "---------------------------------------------------------------------------------"
oc -n ${APP_NS} get is | grep ${APP_NAME}

echo "---------------------------------------------------------------------------------"
echo "- describe is-"
echo "---------------------------------------------------------------------------------"
oc -n ${APP_NS} describe is | grep ${APP_NAME}

