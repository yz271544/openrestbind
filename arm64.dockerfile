#FROM openresty/openresty@sha256:70bb47f11c2d9227c4857943b66188f0255ac94ce11e62ac8178acababc7a780
FROM openresty/openresty:1.27.1.2-bookworm-fat-aarch64
LABEL authors="Lyndon"

RUN sed -i "s/deb.debian.org/mirrors.ustc.edu.cn/g" /etc/apt/sources.list.d/debian.sources
RUN apt update
RUN apt install -y dmidecode sudo

RUN mkdir -p /var/log/nginx
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

COPY teradata-ice-code/bin/IceCode.exe /usr/local/openresty/bin/IceCode.exe
COPY teradata-ice-code/bin/IceCodeAarch64.exe /usr/local/openresty/bin/IceCodeAarch64.exe
COPY lsbkd.lua /usr/local/openresty/bin/lsbkd.lua
COPY lsbk.lua /usr/local/openresty/bin/lsbk.lua
RUN luajit -b /usr/local/openresty/bin/lsbk.lua /usr/local/openresty/bin/lsbke.lua
