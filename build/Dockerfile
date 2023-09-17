FROM node:20-alpine3.17

#设置registry为淘宝镜像
RUN npm config set registry https://registry.npm.taobao.org/
RUN yarn config set registry https://registry.npm.taobao.org/

#替换国内源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

#安装基础软件
RUN apk add --no-cache \
    bash bash-completion supervisor \
    autoconf automake build-base libtool nasm

#配置传参	
ENV TARGET_UID=1000
ENV TARGET_GID=1000
ENV VERSION=latest
ENV WEBSITE_NAME='my-website'
ENV TEMPLATE='classic'

#配置工作目录
RUN mkdir /docusaurus
WORKDIR /docusaurus

#添加运行脚本
ADD config/init.sh /
ADD config/run.sh /
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#确保脚本权限
RUN chmod a+x /init.sh  /run.sh

#设置挂载目录并且启动初始化脚本
VOLUME [ "/docusaurus" ]
ENTRYPOINT [ "/init.sh" ]
