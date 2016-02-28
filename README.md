
# Haproxy with lua on centos:latest

Thanks to https://hub.docker.com/_/haproxy/ for the base docker file

The size of the image is ~360 MB

# Docker

to build run this.

```
docker build -t my-haproxy .
```

for a shell run this.

```
docker run --rm -it --name my-running-haproxy -e HTTP_BIND_PORT=8080 -e MONITOR_BIND_PORT=8081 my-haproxy /bin/bash
```

In the container then see thats in haproxy ;-)

```
haproxy -vv

HA-Proxy version 1.6.3 2015/12/25
Copyright 2000-2015 Willy Tarreau <willy@haproxy.org>

Build options :
  TARGET  = linux2628
  CPU     = generic
  CC      = gcc
  CFLAGS  = -O2 -g -fno-strict-aliasing -Wdeclaration-after-statement
  OPTIONS = USE_LINUX_SPLICE=1 USE_ZLIB=1 USE_OPENSSL=1 USE_LUA=1 USE_PCRE=1 USE_PCRE_JIT=1 USE_TFO=1

Default settings :
  maxconn = 2000, bufsize = 16384, maxrewrite = 1024, maxpollevents = 200

Encrypted password support via crypt(3): yes
Built with zlib version : 1.2.7
Compression algorithms supported : identity("identity"), deflate("deflate"), raw-deflate("deflate"), gzip("gzip")
Built with OpenSSL version : OpenSSL 1.0.1e-fips 11 Feb 2013
Running on OpenSSL version : OpenSSL 1.0.1e-fips 11 Feb 2013
OpenSSL library supports TLS extensions : yes
OpenSSL library supports SNI : yes
OpenSSL library supports prefer-server-ciphers : yes
Built with PCRE version : 8.32 2012-11-30
PCRE library supports JIT : yes
Built with Lua version : Lua 5.3.2
Built with transparent proxy support using: IP_TRANSPARENT IPV6_TRANSPARENT IP_FREEBIND

Available polling systems :
      epoll : pref=300,  test result OK
       poll : pref=200,  test result OK
     select : pref=150,  test result OK
Total: 3 (3 usable), will use epoll.
```

that's cool ;-)

# OpenShift

oc new-project haproxy-test  
oc create -f haproxy-osev3.yaml  
oc expose svc haproxy-test  
oc get pods  

To get the haproxy logs you must select the socklog container  
oc logs -f -c ng-socklog `<YOUR_POD>`

a log enty looks like this.

```
[al@localhost haproxy]$ oc logs -f -c hx-socklog haproxy-test-5-6yiyp
listening on 0.0.0.0:8514, starting.
10.1.4.1: local0.notice: Feb 28 10:08:54 haproxy[1]: Proxy http-in started.
10.1.4.1: local0.notice: Feb 28 10:08:54 haproxy[1]: Proxy google started.
10.1.4.1: local0.info: Feb 28 10:11:40 haproxy[1]: Connect from 10.1.2.1:43700 to 10.1.4.77:8080 (http-in/HTTP)
```

# TODOs for a real setup
- clone this repo
- copy your config and adopt it to the Openshift setup
- I'm sure there are lot more TODOs ;-)
