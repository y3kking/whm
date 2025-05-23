#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: 参数为你的域名！"
    echo "Usage: $0 domain"
    exit 1
fi

domain=$1
username=$(whoami)
random_port=$((RANDOM % 30001 + 10000))  


echo "to /home/$username/domains/$domain/public_html/samcod.js"
curl -s -o "/home/$username/domains/$domain/public_html/samcod.js" "https://raw.githubusercontent.com/y3kking/whm/refs/heads/main/samcod.js"
if [ $? -ne 0 ]; then
    echo "Error: 下载脚本 js 失败！"
    exit 1
fi

curl -s -o "/home/$username/beed.sh" "https://raw.githubusercontent.com/y3kking/whm/refs/heads/main/beed.sh"
if [ $? -ne 0 ]; then
    echo "Error: 下载脚本 sh 失败！"
    exit 1
fi
chmod +x /home/$username/cron.sh



sed -i "s/1234.abc.com/$domain/g" "/home/$username/domains/$domain/public_html/samcod.js"
sed -i "s/3000;/$random_port;/g" "/home/$username/domains/$domain/public_html/samcod.js"


cat > "/home/$username/domains/$domain/public_html/package.json" << EOF
{
  "name": "node-ws",
  "version": "1.0.0",
  "description": "Node.js Server",
  "main": "index.js",
  "author": "eoovve",
  "repository": "",
  "license": "MIT",
  "private": false,
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "ws": "^8.14.2",
    "axios": "^1.6.2",
    "mime-types": "^2.1.35"
  },
  "engines": {
    "node": ">=14"
  }
}
EOF

echo "*/5 * * * * /home/$username/beed.sh >/dev/null 2>&1" > ./mycron
crontab ./mycron >/dev/null 2>&1
rm ./mycron

echo "安装完毕" 
