#!/bin/bash
monitor_path='/root/rocketchat/upload_files/'
remote_server1='192.168.200.127'
remote_server2='192.168.200.128'
rsync_user='root'
rsync_module='rocket_sync'
password_file='/root/rocketchat/rsync.passwd'


/usr/bin/inotifywait -mrq --format '%w%f %e' -e create,close_write,delete,modify $monitor_path | while read line 
do
    file=$(echo ${line} | awk '{print $1}')
    event=$(echo ${line} | awk '{print $2}')
    dir="$(dirname ${file})/"

    if [ ${event} != 'DELETE' ];then
        rsync -av --delete --rsh=ssh ${file}  $rsync_user@$remote_server1::$rsync_module/ --password-file=$password_file --log-file=/var/log/rsync_inotify.log
        rsync -av --delete --rsh=ssh ${file}  $rsync_user@$remote_server2::$rsync_module/ --password-file=$password_file --log-file=/var/log/rsync_inotify.log
    fi

    if [ ${event} == 'DELETE' ];then
		rsync -av --delete --rsh=ssh ${dir}  $rsync_user@$remote_server1::$rsync_module/ --password-file=$password_file --log-file=/var/log/rsync_inotify.log
		rsync -av --delete --rsh=ssh ${dir}  $rsync_user@$remote_server2::$rsync_module/ --password-file=$password_file --log-file=/var/log/rsync_inotify.log
    fi

done