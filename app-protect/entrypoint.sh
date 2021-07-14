#!/usr/bin/env bash

LOGPATH=/var/log/adm/admd.log

# create shared cores if it missing before starting admd

mkdir -p /shared/cores && chmod 755 /shared/cores
/usr/bin/adminstall --daemons 1 --memory 100 > ${LOGPATH} 2>&1
/usr/bin/admd -d --standalone > ${LOGPATH} 2>&1 &
/bin/su -s /bin/bash -c '/opt/app_protect/bin/bd_agent &' nginx
/bin/su -s /bin/bash -c "/usr/share/ts/bin/bd-socket-plugin tmm_count 4 proc_cpuinfo_cpu_mhz 2000000 total_xml_memory 307200000 total_umu_max_size 3129344 sys_max_account_id 1024 no_static_config 2>&1 > /var/log/app_protect/bd-socket-plugin.log &" nginx
/usr/sbin/nginx -g 'daemon off;'
