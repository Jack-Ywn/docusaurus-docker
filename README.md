## 使用docker部署

```shell
docker run -d --name=docusaurus \
	-p 8000:80 \
	-v ./docusaurus:/docusaurus \
	-e TARGET_UID=1000 \
	-e TARGET_GID=1000 \
	-e WEBSITE_NAME="awesometic-docs" \
	-e MAXLISTENRTS=20 \
	-e TEMPLATE=classic \
	jackywn/docusaurus
```



## 使用docker-compose部署

```shell
git clone https://github.com/Jack-Ywn/docusaurus-docker.git

cd docusaurus-docker

docker-compose up -d
```



## 构建容器镜像

```shell
git clone https://github.com/Jack-Ywn/docusaurus-docker.git

cd docusaurus-docker/build

docker build -t jackywn/docusaurus .
```



## Nginx反向代理docusaurus容器

```
server {
    listen 80;
    listen 443 ssl http2;

    server_name                example.com;
    server_name_in_redirect    on;
    port_in_redirect           on;

    if ( $scheme = http ) { return 301 https://$host$request_uri; }

    ssl_certificate          example.com.cer;
    ssl_certificate_key      example.com.key;

    location / {
        proxy_pass  http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Port $server_port;
    }
}
```
