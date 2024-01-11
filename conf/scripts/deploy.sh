#!/bin/bash
# Record start timestamp
start_time=\$(date +%s)
start_timestamp=\$(date)
echo "### Script started at: \$start_timestamp"
# PM2 STOP nextjs and payloadcms
echo "### PM2 STOP nextjs and payloadcms"
sudo pm2 stop nextjs
sudo pm2 stop payloadcms
# GIT FETCH PULL
echo "### GIT FETCH PULL"
sudo -i -u ec2-user bash <<-##EOF##
    cd /$GIT_ROOT_FOLDER/$GIT_FOLDER
    git config pull.rebase true
    git status
    git fetch
    git pull
##EOF##
# PAYLOADCMS BUILD START
echo "### PAYLOADCMS BUILD"
cd /$GIT_ROOT_FOLDER/$GIT_FOLDER/$PAYLOADCMS_FOLDER || exit
sudo yarn install
sudo yarn run build
echo "### PAYLOADCMS START"
sudo pm2 start payloadcms
# NEXTJS BUILD START
echo "### NEXTJS BUILD"
cd /$GIT_ROOT_FOLDER/$GIT_FOLDER/$NEXTJS_FOLDER || exit
sudo yarn install
sudo yarn run build
echo "### NEXTJS START"
sudo pm2 start nextjs
# Record end timestamp and calculate execution time
end_time=\$(date +%s)
end_timestamp=\$(date)
echo "### Script ended at: \$end_timestamp"
execution_time=\$((end_time - start_time))
minutes=\$((execution_time / 60))
seconds=\$((execution_time % 60))
echo "### NextJS     app URL: https://${FULL_DOMAIN}"
echo "### PayloadCMS app URL: https://${FULL_DOMAIN}/admin"
echo "### FINISHED! --> Total execution time: \$minutes minutes and \$seconds seconds"
