#!/usr/bin/env bash

# refresh token flow (to get a new access token)
curl -X POST https://www.strava.com/api/v3/oauth/token \
	-d "client_id=$(pass strava.com/clientID)" \
	-d "client_secret=$(pass strava.com/clientSecret)" \
	-d "refresh_token=$(pass strava.com/userRefreshToken)" \
	-d grant_type=refresh_token | jq -r .access_token
