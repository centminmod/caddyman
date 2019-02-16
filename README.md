## Motivation
- caddyman is a simple script to install [Caddy](https://caddyserver.com) plugins
- [Caddy](https://caddyserver.com) has no smooth way to install plugins, and we have 3 ways
    - [Download](https://caddyserver.com/download) a binary directly with the desired plugins needed
    - Use [Caddyplug](https://github.com/abiosoft/caddyplug) but this only works on linux.
    - Edit some caddy source files, adding proper imports for the desigred plugins then re-build caddy
        - Example: in oprder to add [IYO]() plugin support 

            - we have to edit some source code ```$GOPATH/src/github.com/mholt/caddy/caddy/caddymain/run.go```
        manually,then adding plugin import path before we build caddy again.i.e
            ```
                _ "github.com/mholt/caddy/caddyhttp"
            ```
            - some plugins require you also to add a directive here ```$GOPATH/src/github.com/mholt/caddy/caddyhttp/httpserver/plugin.go```
            in ```directives``` variablea as well for caddy to recognize this directive when used in caddy config file
- Caddyman does the step number 3 for you


## usage
-
```
./caddyman.sh                         
usage: cadyman list                                   (list available plugins)
               listname                               (list plugins name only)
               listcheck                              (curl header check for plugins)
               updatesrc                              (update caddy source)
               install plugin_name1 plugin_name2 ...  (install plugins by their names)
               install_url url {directive}            (install plugin by url)
```


## examples

- List all available plugins that you can install by just name
```
./caddyman.sh list | sort
[authz] github.com/casbin/caddy-authz
[awses] github.com/miquella/caddy-awses
[awslambda] github.com/coopernurse/caddy-awslambda
[azure] github.com/caddyserver/dnsproviders/azure
[cache] github.com/nicolasazrak/caddy-cache
[cgi] github.com/jung-kurt/caddy-cgi
[cloudflare] github.com/caddyserver/dnsproviders/cloudflare
[cors] github.com/captncraig/cors/caddy
[datadog] github.com/payintech/caddy-datadog
[digitalocean] github.com/caddyserver/dnsproviders/digitalocean
[dnsmadeeasy] github.com/caddyserver/dnsproviders/dnsmadeeasy
[dyn] github.com/caddyserver/dnsproviders/dyn
[expires] github.com/epicagency/caddy-expires
[filter] github.com/echocat/caddy-filter
[forwardproxy] github.com/caddyserver/forwardproxy
[geoip] github.com/hiphref/caddy-geoip
[git] github.com/abiosoft/caddy-git
[godaddy] github.com/caddyserver/dnsproviders/godaddy
[googlecloud] github.com/caddyserver/dnsproviders/googlecloud
[gopkg] github.com/zikes/gopkg
[ipfilter] github.com/pyed/ipfilter
[jwt] github.com/BTBurke/caddy-jwt
[linode] github.com/caddyserver/dnsproviders/linode
[locale] github.com/simia-tech/caddy-locale
[login] github.com/tarent/loginsrv/caddy
[mailout] github.com/SchumacherFM/mailout
[minify] github.com/hacdias/caddy-minify
[multipass] github.com/namsral/multipass/caddy
[namecheap] github.com/caddyserver/dnsproviders/namecheap
[net] github.com/pieterlouw/caddy-net
[nobots] github.com/Xumeiquer/nobots
[ns1] github.com/caddyserver/dnsproviders/ns1
[ovh] github.com/caddyserver/dnsproviders/ovh
[pdns] github.com/caddyserver/dnsproviders/pdns
[prometheus] github.com/miekg/caddy-prometheus
[proxyprotocol] github.com/mastercactapus/caddy-proxyprotocol
[rackspace] github.com/caddyserver/dnsproviders/rackspace
[ratelimit] github.com/xuqingfeng/caddy-rate-limit
[realip] github.com/captncraig/caddy-realip
[reauth] github.com/freman/caddy-reauth
[restic] github.com/restic/caddy
[route53] github.com/caddyserver/dnsproviders/route53
[s3browser] github.com/techknowlogick/caddy-s3browser
[search] github.com/pedronasser/caddy-search
[supervisor] github.com/lucaslorentz/caddy-supervisor
[upload] blitznote.com/src/caddy.upload
[vultr] github.com/caddyserver/dnsproviders/vultr
[webdav] github.com/hacdias/caddy-webdav
````


- Install a plugin by name
```
./caddyman.sh install cache realip
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/nicolasazrak/caddy-cache 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/captncraig/caddy-realip 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Ensure caddy build system dependencies [SUCCESS]
Rebuilding caddy binary [SUCCESS]
Copying caddy binary to /root/golang/packages/bin [SUCCESS]
Copying caddy binary to /usr/local/bin/caddy [SUCCESS]
Rebuilding caddy binary GCC optimized [SUCCESS]
Copying caddy GCC optimized binary to /usr/local/bin/caddy-gcc7 [SUCCESS]
Rebuilding caddy binary Clang optimized [SUCCESS]
Copying caddy Clang optimized binary to /usr/local/bin/caddy-clang5 [SUCCESS]
```

- Trying to install a non-existent plugin name
```
./caddyman.sh install hugosss
Plugin name hugosss is not recognized
Ensure caddy build system dependencies [SUCCESS]
Rebuilding caddy binary [SUCCESS]
Copying caddy binary to /root/golang/packages/bin [SUCCESS]
Copying caddy binary to /usr/local/bin/caddy [SUCCESS]
Rebuilding caddy binary GCC optimized [SUCCESS]
Copying caddy GCC optimized binary to /usr/local/bin/caddy-gcc7 [SUCCESS]
Rebuilding caddy binary Clang optimized [SUCCESS]
Copying caddy Clang optimized binary to /usr/local/bin/caddy-clang5 [SUCCESS]
```

- For non supported plugins (not in ```./caddyman list```, you can provide the plugin url
    - Following example, iyo plugin needs a directive called ```oauth``` ```
./caddyman.sh install_by_url github.com/itsyouonline/caddy-integration/oauth oauth```
    - Another example for a plugin that doesn't require a directive ```./caddyman.sh install_by_url github.com/abiosoft/caddy-git```

- Install multiple plugins by name including building 3 separate caddy binaries for default GCC 4.8.5 compile, GCC 7.2.1 and Clang 4.0.1

Minimal selected plugins minus dns providers with exception of cloudflare

```
./caddyman.sh updatesrc
./caddyman.sh install proxyprotocol expires git forwardproxy minify authz locale cache realip ipfilter cors filter cloudflare cgi ratelimit login jwt
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/mastercactapus/caddy-proxyprotocol 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/epicagency/caddy-expires 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/abiosoft/caddy-git 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/forwardproxy 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/hacdias/caddy-minify 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/casbin/caddy-authz 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/simia-tech/caddy-locale 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/nicolasazrak/caddy-cache 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/captncraig/caddy-realip 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/pyed/ipfilter 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/captncraig/cors/caddy 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/echocat/caddy-filter 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/cloudflare 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/jung-kurt/caddy-cgi 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/xuqingfeng/caddy-rate-limit 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/tarent/loginsrv/caddy 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/BTBurke/caddy-jwt 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Ensure caddy build system dependencies [SUCCESS]
Disable Telemetry [SUCCESS]
Rebuilding caddy binary [SUCCESS]
Caddy is Running .. Stopping process [SUCCESS]
Copying caddy binary to /root/golang/packages/bin [SUCCESS]
Copying caddy binary to /usr/local/bin/caddy [SUCCESS]
Rebuilding caddy binary GCC optimized [SUCCESS]
Copying caddy GCC optimized binary to /usr/local/bin/caddy-gcc7 [SUCCESS]
Rebuilding caddy binary Clang optimized [SUCCESS]
Copying caddy Clang optimized binary to /usr/local/bin/caddy-clang5 [SUCCESS]
-rwxr-xr-x 1 root root 19M Feb 16 07:18 /usr/local/bin/caddy
-rwxr-xr-x 1 root root 19M Feb 16 07:18 /usr/local/bin/caddy-clang5
-rwxr-xr-x 1 root root 19M Feb 16 07:18 /usr/local/bin/caddy-gcc7
```

```
caddy --version
Caddy 0.11.4 (+c1d6c92 Sat Feb 16 07:18:10 UTC 2019) (unofficial)
1 file changed, 18 insertions(+), 1 deletion(-)
caddy/caddymain/run.go
```

```
caddy --plugins
Server types:
  http

Caddyfile loaders:
  short
  flag
  default

Other plugins:
  http.authz
  http.basicauth
  http.bind
  http.browse
  http.cache
  http.cgi
  http.cors
  http.errors
  http.expires
  http.expvar
  http.ext
  http.fastcgi
  http.filter
  http.forwardproxy
  http.git
  http.gzip
  http.header
  http.index
  http.internal
  http.ipfilter
  http.jwt
  http.limits
  http.locale
  http.log
  http.login
  http.markdown
  http.mime
  http.minify
  http.pprof
  http.proxy
  http.proxyprotocol
  http.push
  http.ratelimit
  http.realip
  http.redir
  http.request_id
  http.rewrite
  http.root
  http.status
  http.templates
  http.timeouts
  http.websocket
  on
  tls
  tls.cluster.file
  tls.dns.cloudflare
```

Selected plugins minus dns providers with exception of cloudflare

```
./caddyman.sh updatesrc
./caddyman.sh install upload proxyprotocol expires git forwardproxy minify gopkg grpc authz locale cache realip ipfilter mailout cors filter awslambda prometheus awses cloudflare cgi ratelimit login jwt
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS].com/src/caddy.upload 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/mastercactapus/caddy-proxyprotocol 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/epicagency/caddy-expires 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/abiosoft/caddy-git 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/forwardproxy 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/hacdias/caddy-minify 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/zikes/gopkg 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/pieterlouw/caddy-grpc 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/casbin/caddy-authz 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/simia-tech/caddy-locale 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/nicolasazrak/caddy-cache 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/captncraig/caddy-realip 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/pyed/ipfilter 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/SchumacherFM/mailout 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/captncraig/cors/caddy 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/echocat/caddy-filter 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/coopernurse/caddy-awslambda 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/miekg/caddy-prometheus 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/miquella/caddy-awses 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/cloudflare 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/jung-kurt/caddy-cgi 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/xuqingfeng/caddy-rate-limit 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/tarent/loginsrv/caddy 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/BTBurke/caddy-jwt 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Ensure caddy build system dependencies [SUCCESS]
Disable Telemetry [SUCCESS]
Rebuilding caddy binary [SUCCESS]
Caddy is Running .. Stopping process [SUCCESS]
Copying caddy binary to /root/golang/packages/bin [SUCCESS]
Copying caddy binary to /usr/local/bin/caddy [SUCCESS]
Rebuilding caddy binary GCC optimized [SUCCESS]
Copying caddy GCC optimized binary to /usr/local/bin/caddy-gcc7 [SUCCESS]
Rebuilding caddy binary Clang optimized [SUCCESS]
Copying caddy Clang optimized binary to /usr/local/bin/caddy-clang5 [SUCCESS]
-rwxr-xr-x 1 root root 26M Feb 16 06:42 /usr/local/bin/caddy
-rwxr-xr-x 1 root root 26M Feb 16 06:42 /usr/local/bin/caddy-clang5
-rwxr-xr-x 1 root root 26M Feb 16 06:42 /usr/local/bin/caddy-gcc7
```

All plugins

```
./caddyman.sh updatesrc
./caddyman.sh install pdns digitalocean upload proxyprotocol expires git forwardproxy minify gopkg grpc dnsmadeeasy authz datadog nobots route53 locale cache realip ipfilter dyn namecheap webdav mailout cors restic filter awslambda prometheus ns1 awses linode vultr reauth cloudflare cgi googlecloud godaddy ovh ratelimit rackspace azure login jwt
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/pdns 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/digitalocean 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS].com/src/caddy.upload 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/mastercactapus/caddy-proxyprotocol 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/epicagency/caddy-expires 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/abiosoft/caddy-git 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/forwardproxy 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/hacdias/caddy-minify 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/zikes/gopkg 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/pieterlouw/caddy-grpc 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/dnsmadeeasy 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/casbin/caddy-authz 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/payintech/caddy-datadog 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/Xumeiquer/nobots 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/route53 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/simia-tech/caddy-locale 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/nicolasazrak/caddy-cache 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/captncraig/caddy-realip 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/pyed/ipfilter 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/dyn 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/namecheap 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/hacdias/caddy-webdav 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/SchumacherFM/mailout 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/captncraig/cors/caddy 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/restic/caddy 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/echocat/caddy-filter 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/coopernurse/caddy-awslambda 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/miekg/caddy-prometheus 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/ns1 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/miquella/caddy-awses 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/linode 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/vultr 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/freman/caddy-reauth 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/cloudflare 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/jung-kurt/caddy-cgi 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/googlecloud 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/godaddy 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/ovh 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/xuqingfeng/caddy-rate-limit 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/rackspace 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/azure 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/tarent/loginsrv/caddy 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/BTBurke/caddy-jwt 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Ensure caddy build system dependencies [SUCCESS]
Disable Telemetry [SUCCESS]
Rebuilding caddy binary [SUCCESS]
Caddy is Running .. Stopping process [SUCCESS]
Copying caddy binary to /root/golang/packages/bin [SUCCESS]
Copying caddy binary to /usr/local/bin/caddy [SUCCESS]
Rebuilding caddy binary GCC optimized [SUCCESS]
Copying caddy GCC optimized binary to /usr/local/bin/caddy-gcc7 [SUCCESS]
Rebuilding caddy binary Clang optimized [SUCCESS]
Copying caddy Clang optimized binary to /usr/local/bin/caddy-clang5 [SUCCESS]
-rwxr-xr-x 1 root root 35M Feb 16 06:49 /usr/local/bin/caddy
-rwxr-xr-x 1 root root 35M Feb 16 06:49 /usr/local/bin/caddy-clang5
-rwxr-xr-x 1 root root 35M Feb 16 06:49 /usr/local/bin/caddy-gcc7
```

```
/usr/local/bin/caddy -version
Caddy 0.11.4 (+c1d6c92 Sat Feb 16 06:49:05 UTC 2019) (unofficial)
1 file changed, 44 insertions(+), 1 deletion(-)
caddy/caddymain/run.go

/usr/local/bin/caddy-gcc7 -version
Caddy 0.11.4 (+c1d6c92 Sat Feb 16 06:49:13 UTC 2019) (unofficial)
1 file changed, 44 insertions(+), 1 deletion(-)
caddy/caddymain/run.go

/usr/local/bin/caddy-clang5 -version
Caddy 0.11.4 (+c1d6c92 Sat Feb 16 06:49:20 UTC 2019) (unofficial)
1 file changed, 44 insertions(+), 1 deletion(-)
caddy/caddymain/run.go
```

0.11.4 output

```
/usr/local/bin/caddy -plugins
Server types:
  http

Caddyfile loaders:
  short
  flag
  default

Other plugins:
  http.authz
  http.awses
  http.awslambda
  http.basicauth
  http.bind
  http.browse
  http.cache
  http.cgi
  http.cors
  http.datadog
  http.errors
  http.expires
  http.expvar
  http.ext
  http.fastcgi
  http.filter
  http.forwardproxy
  http.git
  http.gopkg
  http.grpc
  http.gzip
  http.header
  http.index
  http.internal
  http.ipfilter
  http.jwt
  http.limits
  http.locale
  http.log
  http.login
  http.mailout
  http.markdown
  http.mime
  http.minify
  http.nobots
  http.pprof
  http.prometheus
  http.proxy
  http.proxyprotocol
  http.push
  http.ratelimit
  http.realip
  http.reauth
  http.redir
  http.request_id
  http.restic
  http.rewrite
  http.root
  http.secrets
  http.status
  http.templates
  http.timeouts
  http.upload
  http.webdav
  http.websocket
  on
  tls
  tls.cluster.file
  tls.dns.azure
  tls.dns.cloudflare
  tls.dns.digitalocean
  tls.dns.dnsmadeeasy
  tls.dns.dyn
  tls.dns.godaddy
  tls.dns.googlecloud
  tls.dns.linode
  tls.dns.namecheap
  tls.dns.ns1
  tls.dns.ovh
  tls.dns.powerdns
  tls.dns.rackspace
  tls.dns.route53
  tls.dns.vultr
```
