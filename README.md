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
    hamdy@hamdy:~/go/src/caddyman$ ./caddyman.sh list
    [upload] blitznote.com/src/caddy.upload
    [search] github.com/pedronasser/caddy-search
    [datadog] github.com/payintech/caddy-datadog
    [nobots] github.com/Xumeiquer/nobots
    [multipass] github.com/namsral/multipass/caddy
    [cache] github.com/nicolasazrak/caddy-cache
    [locale] github.com/simia-tech/caddy-locale
    [hugo] github.com/hacdias/filemanager/caddy/hugo
    [ipfilter] github.com/pyed/ipfilter
    [cors] github.com/captncraig/cors/caddy
    [reauth] github.com/freman/caddy-reauth
    [grpc] github.com/pieterlouw/caddy-grpc
    [jsonp] github.com/pschlump/caddy-jsonp
    [expires] github.com/epicagency/caddy-expires
    [proxyprotocol] github.com/mastercactapus/caddy-proxyprotocol
    [git] github.com/abiosoft/caddy-git
    [minify] github.com/hacdias/caddy-minify
    [gopkg] github.com/zikes/gopkg
    [authz] github.com/casbin/caddy-authz
    [filemanager] github.com/hacdias/filemanager/caddy/filemanager
    [iyo] github.com/itsyouonline/caddy-integration/oauth
    [realip] github.com/captncraig/caddy-realip
    [mailout] github.com/SchumacherFM/mailout
    [webdav] github.com/hacdias/caddy-webdav
    [restic] github.com/restic/caddy
    [awslambda] github.com/coopernurse/caddy-awslambda
    [filter] github.com/echocat/caddy-filter
    [jekyll] github.com/hacdias/filemanager/caddy/jekyll
    [prometheus] github.com/miekg/caddy-prometheus
    [awses] github.com/miquella/caddy-awses
    [cgi] github.com/jung-kurt/caddy-cgi
    [ratelimit] github.com/xuqingfeng/caddy-rate-limit
    [jwt] github.com/BTBurke/caddy-jwt
    [login] github.com/tarent/loginsrv/caddy

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

- Install multiple plugins by name
```
./caddyman.sh install authz awses awslambda cache cgi cors datadog expires filter git gopkg grpc hugo ipfilter jekyll jsonp jwt locale login mailout minify multipass nobots prometheus proxyprotocol ratelimit realip reauth restic search upload webdav            
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
Getting plugin [SUCCESS]m/nicolasazrak/caddy-cache 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/jung-kurt/caddy-cgi 
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
Getting plugin [SUCCESS]m/epicagency/caddy-expires 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/echocat/caddy-filter 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/abiosoft/caddy-git 
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
Installing Hugo [SUCCESS]
Getting plugin [SUCCESS]m/hacdias/filemanager/caddy/hugo 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/pyed/ipfilter 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
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
Getting plugin [SUCCESS]m/Xumeiquer/nobots 
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
Getting plugin [SUCCESS]m/pedronasser/caddy-search 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS].com/src/caddy.upload 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Using GPATH : /root/golang/packages
Ensuring Caddy is up-to-date [SUCCESS]
Getting plugin [SUCCESS]m/hacdias/caddy-webdav 
Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]
Ensure caddy build system dependencies [SUCCESS]
Rebuilding caddy binary [SUCCESS]
Copying caddy binary to /root/golang/packages/bin [SUCCESS]
Copying caddy binary to /usr/local/bin/caddy [SUCCESS]
```

```
/usr/local/bin/caddy -version
Caddy 0.10.9 (+545fa84 Fri Sep 15 14:17:20 UTC 2017)
1 file changed, 32 insertions(+)
caddy/caddymain/run.go
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
  http.filter
  http.git
  http.gopkg
  http.grpc
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
  shutdown
  startup
  tls
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