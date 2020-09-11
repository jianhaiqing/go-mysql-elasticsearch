#!/usr/bin/env bash
#参数检查
if [ -z ${ConfDomain} ] ; then
    echo "请在环境变量配置处设置配置中心域名";
    exit;
fi;

if [ -z ${ConfAppId} ] ; then
    echo "请在环境变量配置处设置配置中心的appId";
    exit;
fi;

if [ -z ${ConfName} ] ; then
    echo "请在环境变量配置处设置配置文件名";
    exit;
fi;

#下载配置文件
wget http://${ConfDomain}/raw/configfiles/${ConfAppId}/default/${ConfName}.toml -O config.toml

#加权限并执行
exec ./go-mysql-elasticsearch -config=config.toml ${BIN_OPTS}
