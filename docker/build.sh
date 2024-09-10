#版本
version=v1
# 镜像名
image_name=flygoose-blog-admin
docker build -t $image_name:$version -f ./Dockerfile ../