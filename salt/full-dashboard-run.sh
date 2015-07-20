#!/bin/bash

echo "Running Registry Refresher"
cd /home/dashboard/IATI-Registry-Refresher
./git.sh > /home/dashboard/logs/$(date +\%Y\%m\%d)-rr.log 2>&1
for i in data/*/; do
    zip -FS -r zips/"`basename $i`.zip" "$i"
done > /home/dashboard/logs/$(date +\%Y\%m\%d)-zips.log 2>&1

echo "Running IATI Stats"
cd /home/dashboard/IATI-Stats
source pyenv/bin/activate
./git_dashboard.sh > /home/dashboard/logs/$(date +\%Y\%m\%d)-stats.log 2>&1
deactivate

echo "Running IATI Dashboard"
cd /home/dashboard/IATI-Dashboard
source pyenv/bin/activate
./git.sh > /home/dashboard/logs/$(date +\%Y\%m\%d)-dashboard.log 2>&1
