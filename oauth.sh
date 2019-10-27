#!/usr/bin/env bash

source common.sh

clientID=$(pass strava.com/clientID)
clientSecret=$(pass strava.com/clientSecret)

scopes=(
	read
	read_all
	profile:read_all
	profile:write
	activity:read
	activity:read_all
	activity:write
)

scopes_string=$(join_by , "${scopes[@]}")

params=(
	"client_id=${clientID}"
	response_type=code
	redirect_uri=http://example.com
	approval_prompt=force
	"scope=${scopes_string}"
)

url=https://www.strava.com/oauth/authorize?$(join_by & "${params[@]}")

echo "$url"
echo
echo "Please follow above link and paste the resulting url after authorization:"

read -r response

: $(grep -o 'code=.*&' <<< "$response")
: ${_%&}
code=${_#code=}

auth_response=$(curl -X POST https://www.strava.com/api/v3/oauth/token \
	-d "client_id=${clientID}" \
	-d "client_secret=${clientSecret}" \
	-d "code=${code}" \
	-d grant_type=authorization_code)

refresh_token=$(jq <<< "${auth_response}" -r .refresh_token)
access_token=$(jq <<< "${auth_response}" -r .access_token)
echo "refresh_token: ${refresh_token}"
echo "access_token: ${access_token}"

exit
