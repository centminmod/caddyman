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
./caddyman
usage: cadyman list                           (list available plugins)
               install plugin_name            (install plugin by its name)
               install_url url {directive}    (install plugin by url)

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
[filemanager] github.com/hacdias/filemanager/caddy/filemanager
[filter] github.com/echocat/caddy-filter
[forwardproxy] github.com/caddyserver/forwardproxy
[git] github.com/abiosoft/caddy-git
[godaddy] github.com/caddyserver/dnsproviders/godaddy
[googlecloud] github.com/caddyserver/dnsproviders/googlecloud
[gopkg] github.com/zikes/gopkg
[hugo] github.com/hacdias/filemanager/caddy/hugo
[ipfilter] github.com/pyed/ipfilter
[iyo] github.com/itsyouonline/caddy-integration/oauth
[jekyll] github.com/hacdias/filemanager/caddy/jekyll
[jsonp] github.com/pschlump/caddy-jsonp
[jwt] github.com/BTBurke/caddy-jwt
[linode] github.com/caddyserver/dnsproviders/linode
[locale] github.com/simia-tech/caddy-locale
[login] github.com/tarent/loginsrv/caddy
[mailout] github.com/SchumacherFM/mailout
[minify] github.com/hacdias/caddy-minify
[multipass] github.com/namsral/multipass/caddy
[namecheap] github.com/caddyserver/dnsproviders/namecheap
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
[search] github.com/pedronasser/caddy-search
[upload] blitznote.com/src/caddy.upload
[vultr] github.com/caddyserver/dnsproviders/vultr
[webdav] github.com/hacdias/caddy-webdav
````


- Install a plugin by name
```
    hamdy@hamdy:~/go/src/caddyman$ ./caddyman.sh install hugo
    Using GPATH : /home/hamdy/go
    Ensuring Caddy is up2date [SUCCESS]
    github.com/hacdias/filemanager/caddy/hugo
    Getting plugin [SUCCESS]
    Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
    Copying caddy binary to //home/hamdy/go/bin [SUCCESS]

```

- Trying to install a non-existent plugin name
```
    hamdy@hamdy:~/go/src/caddyman$ ./caddyman.sh install hugosss
    Plugin name is not recognized

```

- For non supported plugins (not in ```./caddyman list```, you can provide the plugin url
    - Following example, iyo plugin needs a directive called ```oauth``` ```
./caddyman.sh install_by_url github.com/itsyouonline/caddy-integration/oauth oauth```
    - Another example for a plugin that doesn't require a directive ```./caddyman.sh install_by_url github.com/abiosoft/caddy-git```

- Install multiple plugins by name including building 3 separate caddy binaries for default GCC 4.8.5 compile, GCC 7.2.1 and Clang 4.0.1
```
./caddyman.sh install authz awses awslambda azure cache cgi cloudflare cors datadog digitalocean dnsmadeeasy dyn expires filemanager filter forwardproxy git godaddy googlecloud gopkg hugo ipfilter iyo jekyll jsonp jwt linode locale login mailout minify multipass namecheap nobots ns1 ovh pdns prometheus proxyprotocol rackspace ratelimit realip reauth restic route53 search upload vultr webdav
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/casbin/caddy-authz 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/miquella/caddy-awses 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/coopernurse/caddy-awslambda 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/azure 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/nicolasazrak/caddy-cache 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/jung-kurt/caddy-cgi 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/cloudflare 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/captncraig/cors/caddy 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/payintech/caddy-datadog 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/digitalocean 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/dnsmadeeasy 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/dyn 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/epicagency/caddy-expires 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/hacdias/filemanager/caddy/filemanager 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/echocat/caddy-filter 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/forwardproxy 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/abiosoft/caddy-git 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/godaddy 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/googlecloud 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/zikes/gopkg 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Installing Hugo [SUCCESS]
Getting plugin [SUCCESS]m/hacdias/filemanager/caddy/hugo 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/pyed/ipfilter 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/itsyouonline/caddy-integration/oauth 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Updating plugin directive in /root/golang/packages/src/github.com/mholt/caddy/caddyhttp/httpserver/plugin.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/hacdias/filemanager/caddy/jekyll 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/pschlump/caddy-jsonp 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/BTBurke/caddy-jwt 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/linode 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/simia-tech/caddy-locale 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/tarent/loginsrv/caddy 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/SchumacherFM/mailout 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/hacdias/caddy-minify 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/namsral/multipass/caddy 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/namecheap 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/Xumeiquer/nobots 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/ns1 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/ovh 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/pdns 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/miekg/caddy-prometheus 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/mastercactapus/caddy-proxyprotocol 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/rackspace 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/xuqingfeng/caddy-rate-limit 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/captncraig/caddy-realip 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/freman/caddy-reauth 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/restic/caddy 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/route53 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/pedronasser/caddy-search 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS].com/src/caddy.upload 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/caddyserver/dnsproviders/vultr 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/hacdias/caddy-webdav 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Ensure caddy build system dependencies [SUCCESS]
Rebuilding caddy binary [SUCCESS]
Copying caddy binary to /root/golang/packages/bin [SUCCESS]
Copying caddy binary to /usr/local/bin/caddy [SUCCESS]
Rebuilding caddy binary GCC optimized [SUCCESS]
Copying caddy GCC optimized binary to /usr/local/bin/caddy-gcc7 [SUCCESS]
Rebuilding caddy binary Clang optimized [SUCCESS]
Copying caddy Clang optimized binary to /usr/local/bin/caddy-clang4 [SUCCESS]
```

```
/usr/local/bin/caddy -version
Caddy 0.10.10 (+106d62b Mon Feb 19 15:03:38 UTC 2018) (unofficial)
2 files changed, 51 insertions(+)
caddy/caddymain/run.go
caddyhttp/httpserver/plugin.go

/usr/local/bin/caddy-gcc7 -version
Caddy 0.10.10 (+106d62b Mon Feb 19 15:04:27 UTC 2018) (unofficial)
2 files changed, 51 insertions(+)
caddy/caddymain/run.go
caddyhttp/httpserver/plugin.go

/usr/local/bin/caddy-clang4 -version
Caddy 0.10.10 (+106d62b Mon Feb 19 15:05:03 UTC 2018) (unofficial)
2 files changed, 51 insertions(+)
caddy/caddymain/run.go
caddyhttp/httpserver/plugin.go
```

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
  http.filemanager
  http.filter
  http.forwardproxy
  http.git
  http.gopkg
  http.gzip
  http.header
  http.hugo
  http.index
  http.internal
  http.ipfilter
  http.jekyll
  http.jsonp
  http.jwt
  http.limits
  http.locale
  http.log
  http.login
  http.mailout
  http.markdown
  http.mime
  http.minify
  http.multipass
  http.nobots
  http.oauth
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
  http.search
  http.status
  http.templates
  http.timeouts
  http.upload
  http.webdav
  http.websocket
  on
  shutdown
  startup
  tls
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
  tls.storage.file
```

## some useful plugins with full examples
- **filemanager**
    ```
    ./caddyman install filemanager
    mkdir fm
    cd fm
    # create Caddyfile with the following content
    cat > Caddyfile

    http://localhost:2015

    filemanager {
            database        db
            no_auth
    }
    ctrl + D

    # Run caddy
    caddy
    ```
    ![File Manager](assets/fileman.png)

- **hugo**
[hugo](http://gohugo.io/) plugin is a filemanager plugin in its essence
it allows for displaying hugo's generated static files as well as updating them

    ```
    ./caddyman install hugo
    git clone ssh://git@docs.greenitglobe.com:10022/ThreeFold/www_threefold2.0.git
    cd www_threefold2.0.git/
    cat > Caddyfile

        http://localhost:2015

                root www.threefoldtoken.com/en
                hugo www.threefoldtoken.com {
                    database db
                    no_auth
                }


        ctrl + D

        # Run caddy
        caddy
    ```

    ![File Manager](assets/header.png)
    
    ![File Manager](assets/home.png)