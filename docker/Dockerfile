# 打包出前端产物，此步骤可以在本地处理
FROM node:19.9.0-alpine3.17 as builder
# 设置 npm registry 环境变量
ENV NPM_CONFIG_REGISTRY=https://registry.npmmirror.com/
# 取消 ssl 验证 解决报错：npm ERR! code UNABLE_TO_VERIFY_LEAF_SIGNATURE
ENV NPM_CONFIG_STRICT_SSL=false
COPY . /admin
WORKDIR /admin
RUN npm install -g pnpm  \
    && pnpm install --no-frozen-lockfile \
    && pnpm run build

# 使用nginx构建后台镜像
FROM nginx:alpine as runner
WORKDIR /usr/share/nginx/html
COPY --from=builder /admin/dist .
COPY ./docker/env.update.sh .
COPY ./docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY ./docker/.env .
EXPOSE 80

# 执行脚本时出现 env.update.sh: line 47: syntax error: bad substitution 需要安装和使用bash来执行
RUN sed -i 's/\r$//' ./env.update.sh \
    && chmod +x ./env.update.sh \
    && apk add --no-cache bash

ENTRYPOINT ["./env.update.sh"]
# 启动 nginx 服务器
CMD ["nginx", "-g", "daemon off;"]