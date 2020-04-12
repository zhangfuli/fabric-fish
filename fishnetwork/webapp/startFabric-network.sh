LANGUAGE=node
CC_SRC_PATH=/opt/gopath/src/github.com/fishcc

rm -rf ./hfc-key-store

cd ../basic-network

./start.sh
docker-compose -f ./docker-compose.yml up -d cli




echo "npm install 安装依赖文件"
echo "node enrollAdmin.js， 创建管理员，然后执行node registerUser创建用户"
echo "node invoke.js, 调用函数"
echo "node query.js, 查询记录"