FROM centos:centos7
LABEL maintainer "deflinhec <deflinhec@gmail.com>"

ARG LUA
ENV LUA_VERSION=${LUA:-5.2.4} \
    LUAROCKS_VERSION=2.4.2

RUN yum update -y && yum install -y \
        make tar unzip gcc \
        openssl-devel readline-devel curl libc-devel

RUN curl -L http://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz | tar xzf - && \
    \
    cd /lua-$LUA_VERSION && \
    make linux test && \
    make install && \
    \
    rm /lua-$LUA_VERSION -rf

RUN curl -OL https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz && \
    tar xvf luarocks-$LUAROCKS_VERSION.tar.gz && \
    rm luarocks-$LUAROCKS_VERSION.tar.gz && \
    \
    cd /luarocks-$LUAROCKS_VERSION && \
    ./configure \
        --with-lua=/usr/local/ \
        --with-lua-lib=/usr/local/lib/lua \
        --with-lua-include=/usr/local/include && \
    make build && \
    make install && \
    \
    rm -rf /luarocks-$LUAROCKS_VERSION