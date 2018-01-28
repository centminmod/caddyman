#!/bin/bash
###############################################################
SPONSORHEADER='n'
CADDY_BIN='/usr/local/bin/caddy'

CUSTOM_GCCCOMPILED='y'
CUSTOM_CLANGCOMPILED='y'
DEVTOOLSETFOUR='n'
DEVTOOLSETSIX='n'
DEVTOOLSETSEVEN='y'
DEVTOOLSETEIGHT='n'
CLANG_FOUR='y'
CLANG_FIVE='n'
CLANG_SIX='n'
###############################################################

# Dictionary with plugin name as key, URL as value
declare -A plugins_urls=(
    ["authz"]="github.com/casbin/caddy-authz"
    ["awses"]="github.com/miquella/caddy-awses"
    ["awslambda"]="github.com/coopernurse/caddy-awslambda"
    ["cache"]="github.com/nicolasazrak/caddy-cache"
    ["cgi"]="github.com/jung-kurt/caddy-cgi"
    ["cors"]="github.com/captncraig/cors/caddy"
    ["datadog"]="github.com/payintech/caddy-datadog"
    ["expires"]="github.com/epicagency/caddy-expires"
    ["filemanager"]="github.com/hacdias/filemanager/caddy/filemanager"
    ["filter"]="github.com/echocat/caddy-filter"
    ["git"]="github.com/abiosoft/caddy-git"
    ["gopkg"]="github.com/zikes/gopkg"
    ["hugo"]="github.com/hacdias/filemanager/caddy/hugo"
    ["ipfilter"]="github.com/pyed/ipfilter"
    ["iyo"]="github.com/itsyouonline/caddy-integration/oauth"
    ["jekyll"]="github.com/hacdias/filemanager/caddy/jekyll"
    ["jsonp"]="github.com/pschlump/caddy-jsonp"
    ["jwt"]="github.com/BTBurke/caddy-jwt"
    ["locale"]="github.com/simia-tech/caddy-locale"
    ["login"]="github.com/tarent/loginsrv/caddy"
    ["mailout"]="github.com/SchumacherFM/mailout"
    ["minify"]="github.com/hacdias/caddy-minify"
    ["multipass"]="github.com/namsral/multipass/caddy"
    ["nobots"]="github.com/Xumeiquer/nobots"
    ["prometheus"]="github.com/miekg/caddy-prometheus"
    ["proxyprotocol"]="github.com/mastercactapus/caddy-proxyprotocol"
    ["ratelimit"]="github.com/xuqingfeng/caddy-rate-limit"
    ["realip"]="github.com/captncraig/caddy-realip"
    ["reauth"]="github.com/freman/caddy-reauth"
    ["restic"]="github.com/restic/caddy"
    ["search"]="github.com/pedronasser/caddy-search"
    ["upload"]="blitznote.com/src/caddy.upload"
    ["webdav"]="github.com/hacdias/caddy-webdav"
)

# Dictionary with plugin name as key, directive as value
# This holds directives for plugins that should have directive added to caddy!
declare -A plugins_directives=(
    ["iyo"]="oauth"
)

# Use $GOPATH or ~/go if not set!
check_go_path(){
    if [ -n "$GOPATH" ];
        then
            echo "Using GPATH : $GOPATH"
        else
            echo "Setting GOPATH: to ~/go/"
            export GOPATH=~/go/
       fi
}

# Update Caddy source
update_caddy(){
    CADDY_GO_PACKAGE=github.com/mholt/caddy
    echo -ne "Ensuring Caddy is up-to-date \r"
    go get $CADDY_GO_PACKAGE
    echo "Ensuring Caddy is up-to-date [SUCCESS]"
}


# List all supported plugin names and URLS
list(){
    for plugin in "${!plugins_urls[@]}"; do echo "[$plugin] ${plugins_urls[$plugin]}"; done
}


# Print usage message
show_usage(){
    echo "usage: cadyman list                                   (list available plugins)"
    echo "               install plugin_name1 plugin_name2 ...  (install plugins by their names)"
    echo "               install_url url {directive}            (install plugin by url)"
    exit 1
}


# Install plugin given its name or display error message if name not in our supported plugins
install_plugin_by_name(){
    if [ -z ${plugins_urls[$1]} ]; then
        echo "Plugin name is not recognized"
    else
         if [ -z ${plugins_directives[$1]} ]; then
            install ${plugins_urls[$1]} ""
         else
            install ${plugins_urls[$1]} ${plugins_directives[$1]}
         fi
    fi
}

# Install Hugo (only executed if user tries to install hugo plugin)
install_hugo(){

    echo -ne "Installing Hugo \r"
    go get -u github.com/gohugoio/hugo
    echo "Installing Hugo [SUCCESS]"
}

install_plugin(){
    echo -ne "Getting plugin $1 \r"
    go get $1

    if [ ! $? == 0 ]; then
        exit $?
    else
        echo -ne "Getting plugin [SUCCESS]\r"
        echo ""
    fi
}

update_caddy_plugin_imports_and_directives(){

    CADDY_PATH=$GOPATH/src/github.com/mholt/caddy
    PLUGINS_FILE=$CADDY_PATH/caddyhttp/httpserver/plugin.go
    MAIN_FILE=$CADDY_PATH/caddy/caddymain/run.go

    url=$1
    directive=$2

    echo -ne 'Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go\r'
    sed -i "s%This is where other plugins get plugged in (imported)%This is where other plugins get plugged in (imported)\n_ \"$url\"%g" $MAIN_FILE
    gofmt -w $MAIN_FILE
    echo -ne 'Updating plugin imports in $CADDY_PATH/caddy/caddymain/run.go [SUCCESS]\r'
    echo ""

    if [ ! $directive == "" ]; then
        echo -ne "Updating plugin directive in $PLUGINS_FILE\r"
        sed -i "/\"prometheus\",/a \"$directive\"," $PLUGINS_FILE
        gofmt -w $MAIN_FILE
        echo -ne "Updating plugin directive in $PLUGINS_FILE [SUCCESS]\r"
        echo ""
    fi

}

rebuild_caddy(){
    CADDY_PATH=$GOPATH/src/github.com/mholt/caddy

    cd $CADDY_PATH/caddy
    echo -ne "Ensure caddy build system dependencies\r"
    go get -v github.com/caddyserver/builds
    echo "Ensure caddy build system dependencies [SUCCESS]"

    if [[ "$SPONSORHEADER" = [Nn] ]]; then
        SERVERGOPATH="$GOPATH/src/github.com/mholt/caddy/caddyhttp/httpserver/server.go"
        if [[ -f "$SERVERGOPATH" && "$(grep 'Caddy-Sponsors' "$SERVERGOPATH")" && "$(grep 'sponsors' "$SERVERGOPATH")" ]]; then
            sed -ie "/sponsors :/d" "$SERVERGOPATH"
            sed -ie '/Header().Set("Caddy-Sponsors/d' "$SERVERGOPATH"
            if [[ ! "$(grep 'Caddy-Sponsors' "$SERVERGOPATH")" ]]; then
                echo "Removing HTTP Sponsor Header [SUCCESS]"
            elif [[ "$(grep 'Caddy-Sponsors' "$SERVERGOPATH")" ]]; then
                echo "HTTP Sponsor Header Still Detected [FAILED]"
            fi
        fi
    fi

    if [[ "$(uname -m)" = 'x86_64' ]]; then
        OS_ARCH='64'
    else
        OS_ARCH='32'
    fi

    echo -ne "Rebuilding caddy binary\r"
    export CC="gcc"
    export CXX="g++"
    export GOGCCFLAGS="-fPIC -m${OS_ARCH} -pthread -fmessage-length=0"
    export CGO_CFLAGS="-g -O2"
    export CGO_CPPFLAGS=""
    export CGO_CXXFLAGS="-g -O2"
    export CGO_FFLAGS="-g -O2"
    export CGO_LDFLAGS="-g -O2"
    go run build.go
    echo "Rebuilding caddy binary [SUCCESS]"

    if pgrep -x "caddy" > /dev/null

    then
        echo -ne "Caddy is Running .. Stopping process\r"
        kill -9 `pgrep -x caddy` > /dev/null
        echo "Caddy is Running .. Stopping process [SUCCESS]"
    fi

    ##############################################################
    \cp -f caddy "$GOPATH/bin"

    if [ ! $? == 0 ]; then

        exit $?
    else
        echo -n "Copying caddy binary to $GOPATH/bin [SUCCESS]"
        echo ""
    fi

    ##############################################################
    \cp -f caddy "$CADDY_BIN"

    if [ ! $? == 0 ]; then

        exit $?
    else
        echo -n "Copying caddy binary to "$CADDY_BIN" [SUCCESS]"
        echo ""
    fi

    ##############################################################
    if [[ "$CUSTOM_GCCCOMPILED" = [yY] ]]; then

        if [[ "$DEVTOOLSETFOUR" = [yY] && -f /opt/rh/devtoolset-4/root/usr/bin/gcc && -f /opt/rh/devtoolset-4/root/usr/bin/g++ ]]; then
            source /opt/rh/devtoolset-4/enable
            CUSTOM_GCCCOMPILEDYES='y'
            SUFFIX='-gcc5'
        elif [[ "$DEVTOOLSETSIX" = [yY] && -f /opt/rh/devtoolset-6/root/usr/bin/gcc && -f /opt/rh/devtoolset-6/root/usr/bin/g++ ]]; then
            source /opt/rh/devtoolset-6/enable
            CUSTOM_GCCCOMPILEDYES='y'
            SUFFIX='-gcc6'
        elif [[ "$DEVTOOLSETSEVEN" = [yY] &&  -f /opt/rh/devtoolset-7/root/usr/bin/gcc && -f /opt/rh/devtoolset-7/root/usr/bin/g++ ]]; then
            source /opt/rh/devtoolset-7/enable
            CUSTOM_GCCCOMPILEDYES='y'
            SUFFIX='-gcc7'
        elif [[ "$DEVTOOLSETEIGHT" = [yY] && -f /opt/gcc8/bin/gcc && -f /opt/gcc8/bin/g++ ]]; then
            source /opt/gcc8/enable
            CUSTOM_GCCCOMPILEDYES='y'
            SUFFIX='-gcc8'
        else
            SUFFIX=""
        fi

        if [[ "$CUSTOM_GCCCOMPILEDYES" = [yY] ]]; then
            export CC="gcc"
            export CXX="g++"
            export GOGCCFLAGS="-fPIC -m${OS_ARCH} -pthread -fmessage-length=0"
            export CGO_CFLAGS="-g -O3"
            export CGO_CPPFLAGS=""
            export CGO_CXXFLAGS="-g -O3"
            export CGO_FFLAGS="-g -O3"
            export CGO_LDFLAGS="-g -O3"
        
            go run build.go
            echo "Rebuilding caddy binary GCC optimized [SUCCESS]"
        
            \cp -f caddy "${CADDY_BIN}${SUFFIX}"
        
            if [ ! $? == 0 ]; then
        
                exit $?
            else
                echo -n "Copying caddy GCC optimized binary to "${CADDY_BIN}${SUFFIX}" [SUCCESS]"
                echo ""
            fi
        fi
    fi
    ##############################################################
    if [[ "$CUSTOM_CLANGCOMPILED" = [yY] ]]; then

        if [[ "$CLANG_FOUR" = [yY] && -f /opt/sbin/llvm-release_40/bin/clang && -f /opt/sbin/llvm-release_40/bin/clang++ ]]; then
            CLANG_BIN='/opt/sbin/llvm-release_40/bin/clang'
            CUSTOM_CLANGCOMPILEDYES='y'
            SUFFIX='-clang4'
        elif [[ "$CLANG_FOUR" = [yY] && -f /opt/rh/llvm-toolset-7/root/usr/bin/clang && -f /opt/rh/llvm-toolset-7/root/usr/bin/clang++ ]]; then
            CLANG_BIN='/opt/rh/llvm-toolset-7/root/usr/bin/clang'
            CUSTOM_CLANGCOMPILEDYES='y'
            SUFFIX='-clang4'
        elif [[ "$CLANG_FIVE" = [yY] && -f /opt/sbin/llvm-release_50/bin/clang && -f /opt/sbin/llvm-release_50/bin/clang++ ]]; then
            CLANG_BIN='/opt/sbin/llvm-release_50/bin/clang'
            CUSTOM_CLANGCOMPILEDYES='y'
            SUFFIX='-clang5'
        elif [[ "$CLANG_SIX" = [yY] && -f /opt/sbin/llvm-release_60/bin/clang && -f /opt/sbin/llvm-release_60/bin/clang++ ]]; then
            CLANG_BIN='/opt/sbin/llvm-release_60/bin/clang'
            CUSTOM_CLANGCOMPILEDYES='y'
            SUFFIX='-clang6'
        else
            SUFFIX=""
        fi

        if [[ "$CUSTOM_CLANGCOMPILEDYES" = [yY] ]]; then
            export CC="${CLANG_BIN}"
            export CXX="${CLANG_BIN}++"
            export GOGCCFLAGS="-fPIC -m${OS_ARCH} -pthread -fmessage-length=0"
            export CGO_CFLAGS="-g -O3"
            export CGO_CPPFLAGS=""
            export CGO_CXXFLAGS="-g -O3"
            export CGO_FFLAGS="-g -O3"
            export CGO_LDFLAGS="-g -O3"
        
            go run build.go
            echo "Rebuilding caddy binary Clang optimized [SUCCESS]"
        
            \cp -f caddy "${CADDY_BIN}${SUFFIX}"
        
            if [ ! $? == 0 ]; then
        
                exit $?
            else
                echo -n "Copying caddy Clang optimized binary to "${CADDY_BIN}${SUFFIX}" [SUCCESS]"
                echo ""
            fi
        fi
    fi
    ##############################################################
}

install(){
    check_go_path
    update_caddy

    url=$1
    directive=$2

    # special case :: if installing hugo plugin, make sure to install hugo 1st
    if [ $url == "github.com/hacdias/filemanager/caddy/hugo" ]; then
        install_hugo
    fi

    install_plugin $url
    update_caddy_plugin_imports_and_directives $url $directive
}

## START ##

# check proper params
if [[ $# -lt 1 || (  $1 != "list"  &&  $1 != "install" && $1 != "install_url" ) ]]; then
    show_usage
fi

# list takes no extra params
if [ $1 == "list" ]; then
    if [ $# != 1 ]; then
        show_usage
    else
        list
    fi
fi

# install takes multiple plugins names
if [ $1 == "install" ]; then
    if [ $# -lt 2 ]; then
        show_usage
    else
        for plugin_name in ${@:2}; do
            install_plugin_by_name ${plugin_name}
        done
        rebuild_caddy
    fi
fi

# Install URL
if [ $1 == "install_url" ]; then
    if [[ $# -lt 2  || ($# -gt 3) ]]; then
        show_usage
    else
        install $2 $3
        rebuild_caddy
    fi
fi
