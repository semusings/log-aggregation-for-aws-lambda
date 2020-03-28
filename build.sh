#!/usr/bin/env bash
set -e
set -o pipefail

instruction()
{
  echo "usage: ./build.sh deploy <env>"
  echo ""
  echo "env: eg. int, staging, prod, ..."
  echo ""
  echo "for example: ./deploy.sh int"
}

deploy() {

    STAGE=$1

    LOG_FILE=${STAGE}_aws.log
    npm install
    'node_modules/.bin/sls' deploy -s ${STAGE} -v | tee ${LOG_FILE}

    export ServiceEndpoint=$(awk '/ServiceEndpoint:/' ${LOG_FILE} | cut -c18-200)
    echo "API Service Endpoint: ${ServiceEndpoint}"

    echo "----------------------POST------------------------------"
    echo "Testing POST: /orders"
    curl -H "Content-Type: application/json" \
            -X POST --data @Order.json \
            ${ServiceEndpoint}/orders
    echo ""
    echo "--------------------------------------------------------"

    echo "-----------------------GET------------------------------"
    echo "Testing GET: /orders"
    curl -X GET \
            ${ServiceEndpoint}/orders
    echo ""
    echo "--------------------------------------------------------"

    echo ""
}

if [ $# -eq 0 ]; then
  instruction
  exit 1
elif [ "$1" = "deploy" ] && [ $# -eq 2 ]; then
  STAGE=$2
  deploy ${STAGE}
elif [ "$1" = "remove" ] && [ $# -eq 2 ]; then
  STAGE=$2
  echo "Cleanup..."
  'node_modules/.bin/sls' remove -s ${STAGE}
else
  instruction
  exit 1
fi