#!/bin/bash
sudo cat /var/log/cloud-init-output.log
echo "-------------------------------------------------------------------------"
echo "-------------------------------------------------------------------------"
echo "-------------------------------------------------------------------------"
sudo tail -f /var/log/cloud-init-output.log
