#!/bin/bash

usage() { 
	echo "======================================================="
	echo "Usage: $0"
	echo "======================================================="
	echo " [REQUIRED] -c | --config 	        Config file"
    echo " [OPTIONAL] -s | --subscriptionId 	Subscription Id"
    echo "======================================================="
    echo ""
	exit 1; 
}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

for i in "$@"; do
    case $1 in
        "" ) break ;;
        -c | --config ) CONFIGFILE="$2"; shift ;;
        -s | --subscriptionId ) SUBSCRIPTIONID="$2"; shift ;;
        -* | --*) echo "Unknown option: '$1'"; exit 1 ;;
        * ) echo "Unknown argument: '$1'"; exit 1 ;;
    esac
    shift
done

if [ -z "$CONFIGFILE" ]
then
    echo ""
    echo "Missing required -c | --config option"
    echo ""
    usage
    exit 1
fi

if [ -z "$SUBSCRIPTIONID" ]; then
    SUBSCRIPTIONID="$(jq --raw-output .subscriptionId $CONFIGFILE)"
fi

if [ -z "$SUBSCRIPTIONID" ] || [ "$SUBSCRIPTIONID" == "null" ]; then
    echo ""
    echo "A subscriptionId value must be provided in the specified config or by using the -s | --subscriptionId option"
    echo ""
    usage
    exit 1
fi

DEV_CENTER_ID=$(jq --raw-output .devCenterId $CONFIGFILE)
DEPLOY_LOCATION=$(az resource show --ids $DEV_CENTER_ID --query location --output tsv)

echo "Deploying Dev Center Project '$CONFIGFILE' ..."
az deployment sub create \
    --subscription "$SUBSCRIPTIONID" \
    --name $(uuidgen) \
    --location "$DEPLOY_LOCATION" \
    --template-file ./bicep/main.bicep \
    --only-show-errors \
    --parameters \
        config=@$CONFIGFILE \
    --query properties.outputs > ${CONFIGFILE%.*}.output.json && echo "... done"