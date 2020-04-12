LANGUAGE=node
CC_SRC_PATH=/opt/gopath/src/github.com/chaincode/fishcc
VERSION=9.0

rm -rf ./hfc-key-store

cd ../basic-network

./start.sh
docker-compose -f ./docker-compose.yml up -d cli

echo "sleeping 15s"
sleep 15


echo "============install chaincode==============="
# 安装链码
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" cli peer chaincode install -l node -n fishcc -v ${VERSION} -l node -p ${CC_SRC_PATH}


echo "============instantiate chaincode==============="
# 实例化链码
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" cli peer chaincode instantiate -l node -n fishcc -v ${VERSION}  -C mychannel -c '{"args":["init"]}' -o 172.18.0.1:7050

sleep 15

echo "============invoke chaincode==============="
# 测试代码
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" cli peer chaincode invoke -n fishcc -C mychannel -c '{"args":["initLedger"]}' -o 172.18.0.1:7050


echo "============updateHolder==============="
sleep 5

docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" cli peer chaincode invoke -n fishcc -C mychannel -c '{"args":["updateHolder","FISH0","5"]}' -o 172.18.0.1:7050

sleep 5

echo "============query chaincode==============="
# 测试代码
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" cli peer chaincode invoke -n fishcc -C mychannel -c '{"args":["queryFish","FISH0"]}' -o 172.18.0.1:7050


echo "============record fish==============="
sleep 5
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" cli peer chaincode invoke -n fishcc -C mychannel -c '{"args":["recordFish","FISH10","5","4","3","2","1"]}' -o 172.18.0.1:7050


sleep 5

echo "============queryAll chaincode==============="
# 测试代码
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" cli peer chaincode invoke -n fishcc -C mychannel -c '{"args":["queryAllFishes","x"]}' -o 172.18.0.1:7050

sleep 5

echo "============query history==============="
# 测试代码
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" cli peer chaincode invoke -n fishcc -C mychannel -c '{"args":["queryHistory","FISH0"]}' -o 172.18.0.1:7050


echo -e "\n"
echo "npm install 安装依赖文件"
echo "node enrollAdmin.js， 创建管理员，然后执行node registerUser.js创建用户"
echo "node invoke.js, 调用函数"
echo "node query.js, 查询记录"
echo -e "\n"

cd ../webapp
node ./enrollAdmin.js
node ./registerUser.js

