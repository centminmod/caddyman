Whitelist in CSF Firewall /etc/csf/csf.conf TCP/TCP6 in ports for 8080

```
mkdir -p /etc/caddy/conf.d
chown -R root:nginx /etc/caddy
mkdir -p /etc/ssl/caddy
chown -R nginx:root /etc/ssl/caddy
chmod 0770 /etc/ssl/caddy

rm -rf /etc/systemd/system/caddy.service
wget https://github.com/mholt/caddy/raw/master/dist/init/linux-systemd/caddy.service -O /etc/systemd/system/caddy.service
cat /etc/systemd/system/caddy.service
sed -i 's|ProtectHome=true|ProtectHome=false|' /etc/systemd/system/caddy.service
sed -i 's|User=www-data|User=nginx|' /etc/systemd/system/caddy.service
sed -i 's|Group=www-data|Group=nginx|g' /etc/systemd/system/caddy.service
sed -i 's|NoNewPrivileges=true|NoNewPrivileges=false|'  /etc/systemd/system/caddy.service
#sed -i 's|ProtectSystem=full|ProtectSystem=full|' /etc/systemd/system/caddy.service
sed -i "s|ReadWriteDirectories=\/etc\/ssl\/caddy|ReadWriteDirectories=\/etc\/ssl\/caddy\nReadWriteDirectories=\/usr\/local\/nginx|" /etc/systemd/system/caddy.service
sed -i "s|ReadWriteDirectories=\/etc\/ssl\/caddy|ReadWriteDirectories=\/etc\/ssl\/caddy\nReadWriteDirectories=\/usr\/local\/nginx\/logs|" /etc/systemd/system/caddy.service
sed -i "s|ReadWriteDirectories=\/etc\/ssl\/caddy|ReadWriteDirectories=\/etc\/ssl\/caddy\nReadWriteDirectories=\/home\/nginx\/domains|" /etc/systemd/system/caddy.service
sed -i "s|Wants=network-online.target systemd-networkd-wait-online.service|Wants=network-online.target|" /etc/systemd/system/caddy.service
<!-- sed -i 's|;CapabilityBoundingSet=CAP_NET_BIND_SERVICE|CapabilityBoundingSet=CAP_NET_BIND_SERVICE|' /etc/systemd/system/caddy.service -->
<!-- sed -i 's|;AmbientCapabilities=CAP_NET_BIND_SERVICE|AmbientCapabilities=CAP_NET_BIND_SERVICE|' /etc/systemd/system/caddy.service -->

caddy_hostname=$(hostname -f)
cat >/etc/caddy/Caddyfile<<EOF
$caddy_hostname:8080 {
    gzip {
        level 6
        min_length 1400
    }
    browse
    header / {
        #Strict-Transport-Security "max-age=31536000"
        #Cache-Control "max-age=86400"
        X-Content-Type-Options "nosniff"
        X-Frame-Options "SAMEORIGIN"
        X-XSS-Protection "1; mode=block"
        X-Powered-By "Caddy via CentminMod"
        #-Server
    }
    timeouts {
    read   10s
    header 10s
    write  20s
    idle   2m
    }
    tls off
    root /usr/local/nginx/html
    fastcgi / 127.0.0.1:9000 {
        ext   .php
        split .php
        index index.php
        connect_timeout 10s
        read_timeout 10s
        send_timeout 10s
    }
    errors /usr/local/nginx/logs/caddy-mainhost-errors.log {
        rotate_size 100 # Rotate after 100 MB
        rotate_age  14  # Keep log files for 14 days
        rotate_keep 10  # Keep at most 10 log files
        rotate_compress
      }
    log / /usr/local/nginx/logs/caddy-mainhost-access.nossl.log "{remote} {when} {method} {uri} {proto} {status} {size} {>User-Agent} {latency}" {
        rotate_size 100 # Rotate after 100 MB
        rotate_age  14  # Keep log files for 14 days
        rotate_keep 10  # Keep at most 10 log files
        rotate_compress
    }
}
EOF

cat /etc/caddy/Caddyfile

touch /usr/local/nginx/logs/caddy-mainhost-errors.log
chmod 0666 /usr/local/nginx/logs/caddy-mainhost-errors.log
touch /usr/local/nginx/logs/caddy-mainhost-access.nossl.log
chmod 0666 /usr/local/nginx/logs/caddy-mainhost-access.nossl.log

/usr/local/bin/caddy -log stdout -agree=true -conf=/etc/caddy/Caddyfile -root=/var/tmp -validate

setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy
setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy-gcc7
setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy-clang5
systemctl daemon-reload
systemctl start caddy.service
systemctl status caddy.service
journalctl --boot -u caddy --no-pager
journalctl -xe --no-pager | tail -100
systemctl enable caddy.service

tail -100 /usr/local/nginx/losg/caddy-mainhost-errors.log
tail -100 /usr/local/nginx/logs/caddy-mainhost-access.nossl.log
```

```
alias caddysys='nano /etc/systemd/system/caddy.service'
alias caddyconf='nano /etc/caddy/Caddyfile'
alias caddyrestart='systemctl daemon-reload; systemctl restart caddy.service; systemctl status caddy.service;'
```

```
cat /etc/systemd/system/caddy.service
[Unit]
Description=Caddy HTTP/2 web server
Documentation=https://caddyserver.com/docs
After=network-online.target
Wants=network-online.target systemd-networkd-wait-online.service

[Service]
Restart=on-abnormal

; User and group the process will run as.
User=nginx
Group=nginx

; Letsencrypt-issued certificates will be written to this directory.
Environment=CADDYPATH=/etc/ssl/caddy

; Always set "-root" to something safe in case it gets forgotten in the Caddyfile.
;ExecStart=/usr/local/bin/caddy -log stdout -agree=true -conf=/etc/caddy/Caddyfile -root=/var/tmp
ExecStart=/usr/local/bin/caddy -log /var/log/caddy.log -agree=true -conf=/etc/caddy/Caddyfile -root=/var/tmp
; ExecStart=/usr/local/bin/caddy-gcc7 -log stdout -agree=true -conf=/etc/caddy/Caddyfile -root=/var/tmp
; ExecStart=/usr/local/bin/caddy-gcc7 -log /var/log/caddy.log -agree=true -conf=/etc/caddy/Caddyfile -root=/var/tmp
; ExecStart=/usr/local/bin/caddy-clang5 -log stdout -agree=true -conf=/etc/caddy/Caddyfile -root=/var/tmp
; ExecStart=/usr/local/bin/caddy-clang5 -log /var/log/caddy.log -agree=true -conf=/etc/caddy/Caddyfile -root=/var/tmp
ExecReload=/bin/kill -USR1 $MAINPID

; Use graceful shutdown with a reasonable timeout
KillMode=mixed
KillSignal=SIGQUIT
TimeoutStopSec=5s

; Limit the number of file descriptors; see `man systemd.exec` for more limit settings.
LimitNOFILE=1048576
; Unmodified caddy is not expected to use more than that.
LimitNPROC=512

; Use private /tmp and /var/tmp, which are discarded after caddy stops.
PrivateTmp=true
; Use a minimal /dev
PrivateDevices=true
; Hide /home, /root, and /run/user. Nobody will steal your SSH-keys.
ProtectHome=false
; Make /usr, /boot, /etc and possibly some more folders read-only.
ProtectSystem=full
; … except /etc/ssl/caddy, because we want Letsencrypt-certificates there.
;   This merely retains r/w access rights, it does not add any new. Must still be writable on the host!
ReadWriteDirectories=/etc/ssl/caddy
ReadWriteDirectories=/usr/local/nginx/logs
ReadWriteDirectories=/usr/local/nginx
ReadWriteDirectories=/home/nginx/domains

; The following additional security directives only work with systemd v229 or later.
; They further retrict privileges that can be gained by caddy. Uncomment if you like.
; Note that you may have to add capabilities required by any plugins in use.
;CapabilityBoundingSet=CAP_NET_BIND_SERVICE
;AmbientCapabilities=CAP_NET_BIND_SERVICE
;NoNewPrivileges=false

[Install]
WantedBy=multi-user.target
```

Additional Caddy instances for caddy-gcc7 and caddy-clang4 built binaries

```
cp -a /etc/systemd/system/caddy.service /etc/systemd/system/caddy8081.service
cp -a /etc/systemd/system/caddy.service /etc/systemd/system/caddy8082.service
sed -i 's|||' /etc/systemd/system/caddy8081.service
sed -i 's|||' /etc/systemd/system/caddy8082.service
```

```
caddy_hostname=$(hostname -f)
cat >/etc/caddy/Caddyfile8081<<EOF
$caddy_hostname:8081 {
    gzip {
        level 6
        min_length 1400
    }
    browse
    header / {
        #Strict-Transport-Security "max-age=31536000"
        #Cache-Control "max-age=86400"
        X-Content-Type-Options "nosniff"
        X-Frame-Options "SAMEORIGIN"
        X-XSS-Protection "1; mode=block"
        X-Powered-By "Caddy via CentminMod"
        #-Server
    }
    timeouts {
    read   10s
    header 10s
    write  20s
    idle   2m
    }
    tls off
    root /usr/local/nginx/html
    fastcgi / 127.0.0.1:9000 {
        ext   .php
        split .php
        index index.php
        connect_timeout 10s
        read_timeout 10s
        send_timeout 10s
    }
    errors /usr/local/nginx/logs/caddy-mainhost8081-errors.log {
        rotate_size 100 # Rotate after 100 MB
        rotate_age  14  # Keep log files for 14 days
        rotate_keep 10  # Keep at most 10 log files
        rotate_compress
      }
    log / /usr/local/nginx/logs/caddy-mainhost8081-access.nossl.log "{remote} {when} {method} {uri} {proto} {status} {size} {>User-Agent} {latency}" {
        rotate_size 100 # Rotate after 100 MB
        rotate_age  14  # Keep log files for 14 days
        rotate_keep 10  # Keep at most 10 log files
        rotate_compress
    }
}
EOF
```

```
caddy_hostname=$(hostname -f)
cat >/etc/caddy/Caddyfile8082<<EOF
$caddy_hostname:8082 {
    gzip {
        level 6
        min_length 1400
    }
    browse
    header / {
        #Strict-Transport-Security "max-age=31536000"
        #Cache-Control "max-age=86400"
        X-Content-Type-Options "nosniff"
        X-Frame-Options "SAMEORIGIN"
        X-XSS-Protection "1; mode=block"
        X-Powered-By "Caddy via CentminMod"
        #-Server
    }
    timeouts {
    read   10s
    header 10s
    write  20s
    idle   2m
    }
    tls off
    root /usr/local/nginx/html
    fastcgi / 127.0.0.1:9000 {
        ext   .php
        split .php
        index index.php
        connect_timeout 10s
        read_timeout 10s
        send_timeout 10s
    }
    errors /usr/local/nginx/logs/caddy-mainhost8082-errors.log {
        rotate_size 100 # Rotate after 100 MB
        rotate_age  14  # Keep log files for 14 days
        rotate_keep 10  # Keep at most 10 log files
        rotate_compress
      }
    log / /usr/local/nginx/logs/caddy-mainhost8082-access.nossl.log "{remote} {when} {method} {uri} {proto} {status} {size} {>User-Agent} {latency}" {
        rotate_size 100 # Rotate after 100 MB
        rotate_age  14  # Keep log files for 14 days
        rotate_keep 10  # Keep at most 10 log files
        rotate_compress
    }
}
EOF
```