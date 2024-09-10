#!/bin/bash
# 脚本在任何命令失败时退出
set -e

# 重新创建配置文件
absolute_path=$(cd `dirname $0`; pwd)
env_config=${absolute_path}/env.js

rm -rf ${env_config}
touch ${env_config}

# Add assignment
echo "export default {" >> ${env_config}

# 读取.env文件的每一行
# 每一行表示键值
sed -i '/^[[:space:]]*$/d' ${absolute_path}/.env
while read -r line || [[ -n "$line" ]];
do
    # 以#开始的行为注释行，跳过
    if echo "$line" | grep -q "^#"; then
            continue
    fi

    # 通过字符`=`分割环境变量
    if printf '%s\n' "$line" | grep -q -e '='; then
      varname=$(printf '%s\n' "$line" | sed -e 's/=.*//')
      varvalue=$(printf '%s\n' "$line" | sed -e 's/^[^=]*=//')

      # 去除变量名和变量值的前后空格
      varname=$(echo "${varname}" | xargs)
      varvalue=$(echo "${varvalue}" | xargs)
    fi

    # 确保 varname 不为空
    if [ -n "${varname}" ]; then
        # 尝试从环境变量中获取变量的值，如果环境变量中不存在，则使用从文件中读取的值。
        value=$(printf '%s\n' "${!varname}")
        if [ -z "${value}" ]; then
            value=${varvalue}
        fi

        # 将变量名和值以key: 'value'的形式写入到env.js文件中
        echo "  $varname: '$value'," >> ${env_config}
    fi
done < ${absolute_path}/.env
echo "}" >> ${env_config}
cat ${env_config}

exec "$@"