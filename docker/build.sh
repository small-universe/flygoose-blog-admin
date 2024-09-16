#!/bin/bash

# 检查.env 文件是否存在
if [ ! -f .env ]; then
    echo ".env 文件不存在"
    exit 1
fi

# 定义一个关联数组用于存储变量名和值
declare -A variables

# 读取.env 文件中的每一行
while read -r line;
do
    # 忽略以 # 开头的注释行
    if [[ $line != \#* ]]; then
        var_name=$(echo "$line" | cut -d '=' -f 1)
        var_value=$(echo "$line" | cut -d '=' -f 2)
        variables["$var_name"]="$var_value"
    fi
done <.env

# 镜像名 和 版本号 配置
image_name="${variables["IMAGE_NAME"]}"
version="${variables["VERSION"]}"

docker build --no-cache -t $image_name:$version -f ./Dockerfile ../