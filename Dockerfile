# FROM centos:latest
FROM registry.access.redhat.com/rhel7:latest

# take a look at http://www.lua.org/download.html for
# newer version

ENV HAPROXY_MAJOR=1.6 \
    HAPROXY_VERSION=1.6.8 \
    HAPROXY_MD5=8cb3719013e7f34c6d689dabf8a8cd6e \
    LUA_VERSION=5.3.3 \
    LUA_URL=http://www.lua.org/ftp/lua-5.3.3.tar.gz \
    LUA_MD5=703f75caa4fdf4a911c1a72e67a27498 \
    buildDeps='pcre-devel openssl-devel gcc make zlib-devel readline-devel openssl tar'

# RUN cat /etc/redhat-release
# RUN yum provides "*lib*/libc.a"

# see http://git.haproxy.org/?p=haproxy-1.6.git;a=blob_plain;f=Makefile;hb=HEAD
# for some helpful navigation of the possible "make" arguments

RUN set -x \
  && yum -y update \
  && yum -y install pcre openssl-libs zlib bind-utils curl socat ${buildDeps} \
  && curl -SL ${LUA_URL} -o lua-${LUA_VERSION}.tar.gz \
  && echo "${LUA_MD5} lua-${LUA_VERSION}.tar.gz" | md5sum -c \
  && mkdir -p /usr/src/lua \
  && tar -xzf lua-${LUA_VERSION}.tar.gz -C /usr/src/lua --strip-components=1 \
  && rm lua-${LUA_VERSION}.tar.gz \
  && make -C /usr/src/lua linux test install \
  && curl -SL "http://www.haproxy.org/download/${HAPROXY_MAJOR}/src/haproxy-${HAPROXY_VERSION}.tar.gz" -o haproxy.tar.gz \
  && echo "${HAPROXY_MD5}  haproxy.tar.gz" | md5sum -c \
  && mkdir -p /usr/src/haproxy \
  && tar -xzf haproxy.tar.gz -C /usr/src/haproxy --strip-components=1 \
  && rm haproxy.tar.gz \
  && make -C /usr/src/haproxy \
		TARGET=linux2628 \
		USE_PCRE=1 \
		USE_OPENSSL=1 \
		USE_ZLIB=1 \
    USE_LINUX_SPLICE=1 \
    USE_TFO=1 \
    USE_PCRE_JIT=1 \
    USE_LUA=1 \
		all \
		install-bin \
  && mkdir -p /usr/local/etc/haproxy \
  && mkdir -p /usr/local/etc/haproxy/ssl \
  && mkdir -p /usr/local/etc/haproxy/ssl/cas \
  && mkdir -p /usr/local/etc/haproxy/ssl/crts \
	&& cp -R /usr/src/haproxy/examples/errorfiles /usr/local/etc/haproxy/errors \
	&& rm -rf /usr/src/haproxy /usr/src/lua \
	&& yum -y autoremove $buildDeps \
  && yum -y clean all

#         && openssl dhparam -out /usr/local/etc/haproxy/ssl/dh-param_4096 4096 \

COPY containerfiles /

CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.conf"]
#CMD ["haproxy", "-vv"]
