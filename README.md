# OpenResty Bind

```shell
luajit -b lsbk.lua lsbk.out
eval $(luajit lsbk.out)
echo $BIND_MACHINE
```


## build

```shell
docker build -t registry.cn-beijing.aliyuncs.com/dc_huzy/openresty:noble .
```
