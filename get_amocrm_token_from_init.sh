#!/bin/bash

INIT_FILE=init.json
TOKEN_JSON=token.json
DOMAIN=$1

function createTemplate() {
  cat >$INIT_FILE <<EOL
{
  "redirect_uri": "",
  "client_secret": "",
  "client_id": "",
  "code": "",
  "grant_type": "authorization_code"
}
EOL
}

function createToken() {
  SECONDS_EXPIRE=$(echo $3 | jq '.expires_in')
  cat >$TOKEN_JSON <<EOL
{
  "domain": "$1",
  "redirect_uri": $(cat $2 | jq '.redirect_uri'),
  "client_secret": $(cat $2 | jq '.client_secret'),
  "client_id": $(cat $2 | jq '.client_id'),
  "access_token": $(echo $3 | jq '.access_token'),
  "access_token_expire": "$(date --date="+$SECONDS_EXPIRE seconds" +"%Y-%m-%dT%T.%N%:z")",
  "refresh_token": $(echo $3 | jq '.refresh_token')
}
EOL
}

if [ -z "$DOMAIN" ]; then
  echo "Usage $0 <amocrm_domain_url>"
  echo "Example:"
  echo "$0 https://some.amocrm.ru"
  createTemplate
  echo "Fill template $INIT_FILE and run again";
  exit 1
fi

echo "Using $INIT_FILE"
RESP=$(curl -s "$DOMAIN/oauth2/access_token" -H 'Content-Type: application/json' --data-binary @$INIT_FILE)

ACCESS_TOKEN=$(echo $RESP | jq '.access_token')
if [ "$ACCESS_TOKEN" == "null" ]; then
  echo "Error:"
  echo $RESP | jq
  exit 1
fi

echo "Creating $TOKEN_JSON"
createToken "$DOMAIN" "$INIT_FILE" "$RESP"

