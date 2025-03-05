FROM openresty/openresty:noble-amd64
LABEL authors="Lyndon"

RUN apt update
RUN apt install -y dmidecode sudo

COPY bin/IceCode.exe /usr/local/openresty/bin/IceCode.exe
COPY lsbkd.lua /usr/local/openresty/bin/lsbkd.lua
COPY lsbk.lua /usr/local/openresty/bin/lsbk.lua
COPY check_license.lua /usr/local/openresty/bin/check_license.lua

