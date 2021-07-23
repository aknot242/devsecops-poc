#!/usr/bin/env bash

# push env var values into template and create nginx.conf
envsubst '${APP_FQDN} ${APP_FQDN}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Call script to register deployment with Elasticsearch
/bin/bash /root/register-deploy.sh

mkdir -p /shared/cores && chmod 755 /shared/cores
/usr/bin/adminstall --daemons 1 --memory 200 > /var/log/adm/admd.log 2>&1
/bin/su -s /bin/bash -c '/opt/app_protect/bin/bd_agent &' nginx
/bin/su -s /bin/bash -c "/usr/share/ts/bin/bd-socket-plugin tmm_count 4 proc_cpuinfo_cpu_mhz 2000000 total_xml_memory 307200000 total_umu_max_size 3129344 sys_max_account_id 1024 no_static_config 2>&1 > /var/log/app_protect/bd-socket-plugin.log &" nginx
/bin/su -s /bin/bash -c '/usr/bin/admd -d --log info 2>&1 > /var/log/adm/admd.log &' nginx
/usr/sbin/nginx -g 'daemon off;'
