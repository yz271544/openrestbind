FROM openresty/openresty:1.27.1.2-bookworm-fat-aarch64
LABEL authors="Lyndon"

RUN apt update
RUN apt install -y dmidecode sudo

COPY teradata-ice-code/bin/IceCode.exe /usr/local/openresty/bin/IceCode.exe
COPY teradata-ice-code/bin/IceCodeAarch64.exe /usr/local/openresty/bin/IceCodeAarch64.exe
COPY lsbkd.lua /usr/local/openresty/bin/lsbkd.lua
COPY lsbk.lua /usr/local/openresty/bin/lsbk.lua
RUN luajit /usr/local/openresty/bin/lsbk.lua /usr/local/openresty/bin/lsbke.lua
