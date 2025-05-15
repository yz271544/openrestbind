FROM openresty/openresty:1.27.1.2-bookworm-fat

LABEL authors="Lyndon"

RUN apt update
RUN apt install -y dmidecode sudo

RUN mkdir -p /var/log/nginx
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

COPY teradata-ice-code/bin/IceCode.exe /usr/local/openresty/bin/IceCode.exe
COPY teradata-ice-code/bin/IceCodeAarch64.exe /usr/local/openresty/bin/IceCodeAarch64.exe
COPY lsbk.lua /usr/local/openresty/bin/lsbk.lua

RUN luajit -b /usr/local/openresty/bin/lsbk.lua /usr/local/openresty/bin/lsbkd.lua
RUN rm -f /usr/local/openresty/bin/lsbk.lua
