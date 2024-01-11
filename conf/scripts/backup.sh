#!/bin/bash
# Record start timestamp
start_time=\$(date +%s)
start_timestamp=\$(date)
echo "### Script started at: \$start_timestamp"
# PM2 STOP nextjs and payloadcms
echo "### PM2 STOP nextjs and payloadcms"
sudo pm2 stop nextjs
sudo pm2 stop payloadcms
# MongoDB Dump
echo "### MongoDB Dump"
timestamp=\$(date "+%Y-%m-%d_%H-%M-%S")
cd /git/payloadcms-nextjs-separate/payload-2.6/data
mongodump --uri="mongodb://localhost:27017/$MONGODB_NAME" --archive="\${timestamp}_payload_2-6.gz"

# PM2 START nextjs and payloadcms
echo "### PM2 START nextjs and payloadcms"
sudo pm2 start nextjs
sudo pm2 start payloadcms

# GIT PUSH
echo "### GIT PUSH"
sudo -i -u ec2-user bash <<-##EOF##
    cd /git/payloadcms-nextjs-separate
    git add .
    git commit -m "mongodb backup ${timestamp}"
    git push
##EOF##
# Record end timestamp and calculate execution time
end_time=$(date +%s)
end_timestamp=$(date)
echo "### Script ended at: $end_timestamp"
execution_time=$((end_time - start_time))
minutes=$((execution_time / 60))
seconds=$((execution_time % 60))
echo "### NextJS     app URL: https://cms7.schminkel.net"
echo "### PayloadCMS app URL: https://cms7.schminkel.net/admin"
#echo "### NextJS     app URL: https://${FULL_DOMAIN}"
#echo "### PayloadCMS app URL: https://${FULL_DOMAIN}/admin"
echo "### FINISHED! --> Total execution time: $minutes minutes and $seconds seconds"
