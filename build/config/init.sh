#!/usr/bin/env bash

#传参信息
msg() {
    echo -E "/* $1 */"
}

#设置站点目录信息
DOCU_PATH="/docusaurus"
WEB_SRC_PATH="$DOCU_PATH"/website

echo -e "Variables:
\\t- UID=${TARGET_UID}
\\t- GID=${TARGET_GID}
\\t- WEBSITE_NAME=${WEBSITE_NAME}
\\t- VERSION=${VERSION}
\\t- TEMPLATE=${TEMPLATE}"

#必须配置WEBSITE_NAME
[[ -z "$WEBSITE_NAME" ]] && \
    msg "You have to enter your website name. Program will be closed." && exit

#初始化安装docusaurus	
if [[ ! -d "$DOCU_PATH"/"$WEBSITE_NAME" ]]; then
    msg "Install docusaurus..."
    npx create-docusaurus@"$VERSION" "$WEBSITE_NAME" "$TEMPLATE" &
    [[ "$!" -gt 0 ]] && wait $!
    ln -s "$DOCU_PATH"/"$WEBSITE_NAME" "$WEB_SRC_PATH"
    chown -R "$TARGET_UID":"$TARGET_GID" "$DOCU_PATH"
else
    chown -R "$TARGET_UID":"$TARGET_GID" "$DOCU_PATH"
    msg "Docusaurus configuration already exists in the target directory $DOCU_PATH"
fi

#检查安装依赖
if [[ ! -d "$DOCU_PATH"/"$WEBSITE_NAME"/node_modules ]]; then
    msg "Installing node modules..."
    cd "$DOCU_PATH"/"$WEBSITE_NAME"
    yarn install &
    [[ "$!" -gt 0 ]] && wait $!
    cd ..
    ln -sf "$DOCU_PATH"/"$WEBSITE_NAME" "$WEB_SRC_PATH"
    chown -R "$TARGET_UID":"$TARGET_GID" "$DOCU_PATH"
else
    msg "Node modules already exist in $DOCU_PATH/$WEBSITE_NAME/node_modules"
fi

#开启服务
msg "Start supervisord to start Docusaurus..."
supervisord -c /etc/supervisor/conf.d/supervisord.conf
