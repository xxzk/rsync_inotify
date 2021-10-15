## 使用說明 How to use


這個腳本用於 RocketChat HA 架構，檔案儲存類型從原本的 MongoDB `GridFS` 改成 `FileSystem` 後必須將三個 `node` 底下的檔案互相同步達到一致。


### 環境需求 Requirement


- inotify_tools
- rsync
- ssh


## 變數說明 shell script variables


- `monitor_path` inotify_tools 監測的路徑。
- `remote_server{1,2}` 另外兩台 node 的 IP。
- `rsync_user` rsync 使用的使用者。
- `rsync_module` rsync daemond 模式下模組的名稱 (定義在 server side `/etc/rsyncd.conf`)。
- `password_file` 認證用的 credential file 裡面包含密碼。


## 其它建議 Suggestion


- ssh 免密碼登入 (public key)。
- 調整 `/proc/sys/fs/inotify/` 底下的系統參數。


---

## systemd service


```bash
vim /etc/systemd/system/inotify_rsync.service
chmod 644 /etc/systemd/system/inotify_rsync.service
systemctl daemon-reload
systemctl enable --now inotify_rsync.service
systemctl status inotify_rsync.service
```


```service
[Unit]
Description=inotify_rsync

[Service]
Type=simple
ExecStart=/root/rocketchat/inotify_rsync.sh
Restart=always

[Install]
WantedBy=multi-user.target
```