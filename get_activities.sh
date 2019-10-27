#!/usr/bin/env bash

source common.sh

token=$(./refresh-token.sh)
for month in {6..10}; do
	end_of_month=$(gdate -d "$((month+1))/01/2019" +%s)
	start_of_month=$(gdate -d "${month}/01/2019" +%s)
	params=(
		"before=${end_of_month}"
		"after=${start_of_month}"
		'per_page=1000'
	)
	curl -X GET \
		-H "Authorization: Bearer ${token}" \
		"https://www.strava.com/api/v3/athlete/activities?$(join_by '&' "${params[@]}")" > "${month}.json"
done

exit

jq '.[] | select (.type == "Run").id' {9,10}.json | while read -r id; do
	curl -X PUT \
		-H "Authorization: Bearer ${token}" \
		"https://www.strava.com/api/v3/activities/${id}" \
		-F "gear_id=${gear_id}"
done
