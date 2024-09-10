# 打包出前端产物，此步骤可以在本地处理
#FROM node:18.19-alpine3.18 as builder
#COPY . /flygoose-blog-admi
#WORKDIR /flygoose-blog-admi
#RUN npm install -g pnpm --registry=https://registry.npmmirror.com \
#    && pnpm install --no-frozen-lockfile --registry=https://registry.npmmirror.com \
#    && pnpm run build

# 使用nginx构建后台镜像
FROM nginx:alpine as runner
WORKDIR /usr/share/nginx/html
COPY ./dist .
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