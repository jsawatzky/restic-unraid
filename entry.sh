#!/bin/bash

echo "Restic version: $(restic version)"

cat /etc/cron.d/crontab.tmpl | envsubst > /etc/cron.d/crontab

supercronic -test /etc/cron.d/crontab || exit 1

supercronic /etc/cron.d/crontab