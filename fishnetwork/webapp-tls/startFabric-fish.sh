LANGUAGE=node
CC_SRC_PATH=/opt/gopath/src/github.com/chaincode/fishcc
VERSION=4.0

rm -rf ./hfc-key-store

cd ../fish-network

./start.sh

# 安装链码
sleep 5
echo "============install chaincode on peer0org1==============="
docker exec -e "VERSION=4.0" -e "CC_SRC_PATH=/opt/gopath/src/github.com/chaincode/fishcc" -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_ADDRESS=peer0.org1.example.com:7051" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" cli peer chaincode install -n fishcc -v ${VERSION} -l node -p ${CC_SRC_PATH}
echo "============end install chaincode on peer0org1==============="




sleep 5
echo "============install chaincode on peer1org1==============="
docker exec -e "VERSION=4.0" -e "CC_SRC_PATH=/opt/gopath/src/github.com/chaincode/fishcc" -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_ADDRESS=peer1.org1.example.com:8051" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt" cli peer chaincode install -n fishcc -v ${VERSION} -l node -p ${CC_SRC_PATH}
echo "============end install chaincode on peer1org1==============="


sleep 5
echo "============install chaincode on peer2org1==============="
docker exec -e "VERSION=4.0" -e "CC_SRC_PATH=/opt/gopath/src/github.com/chaincode/fishcc" -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_ADDRESS=peer2.org1.example.com:9051" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/ca.crt" cli peer chaincode install -n fishcc -v ${VERSION} -l node -p ${CC_SRC_PATH}
echo "============end install chaincode on peer2org1==============="


sleep 5
echo "============install chaincode on peer0org2==============="
docker exec -e "VERSION=4.0" -e "CC_SRC_PATH=/opt/gopath/src/github.com/chaincode/fishcc" -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_ADDRESS=peer0.org2.example.com:10051" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" cli peer chaincode install -n fishcc -v ${VERSION} -l node -p ${CC_SRC_PATH}
echo "============end install chaincode on peer0org2==============="


sleep 5
echo "============install chaincode on peer1org2==============="
docker exec -e "VERSION=4.0" -e "CC_SRC_PATH=/opt/gopath/src/github.com/chaincode/fishcc" -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_ADDRESS=peer1.org2.example.com:11051" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt" cli peer chaincode install -n fishcc -v ${VERSION} -l node -p ${CC_SRC_PATH}
echo "============end install chaincode on peer1org2==============="

sleep 5
echo "============install chaincode on peer2org2==============="
docker exec -e "VERSION=4.0" -e "CC_SRC_PATH=/opt/gopath/src/github.com/chaincode/fishcc" -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_ADDRESS=peer2.org2.example.com:12051" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/ca.crt" cli peer chaincode install -n fishcc -v ${VERSION} -l node -p ${CC_SRC_PATH}
echo "============end install chaincode on peer2org2==============="




# 实例化链码
sleep 5
echo "============init chaincode peer0org2==============="
docker exec -e "VERSION=4.0" -e "CHANNEL_NAME=mychannel" -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e "CORE_PEER_ADDRESS=peer0.org2.example.com:10051" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" cli peer chaincode instantiate -l node -n fishcc -v ${VERSION}  -C mychannel -c '{"args":["init"]}' -P "OR ('Org1MSP.peer','Org2MSP.peer')" -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem
echo "============end init chaincode peer0org2==============="


sleep 5
echo "============initLedger peer0org2==============="
docker exec -e "VERSION=4.0" -e "CHANNEL_NAME=mychannel" -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e "CORE_PEER_ADDRESS=peer0.org2.example.com:10051" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" cli peer chaincode invoke -n fishcc -C mychannel -c '{"args":["initLedger"]}' -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem
echo "============end initLedger peer0org2==============="


sleep 5
echo "============updateHolder peer2org1==============="
docker exec -e "VERSION=4.0" -e "CHANNEL_NAME=mychannel" -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" -e "CORE_PEER_ADDRESS=peer2.org1.example.com:9051" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/ca.crt" cli peer chaincode invoke -n fishcc -C mychannel -c '{"args":["updateHolder","FISH0","5"]}' -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem
echo "============end updateHolder==============="


sleep 5
echo "============query chaincode peer2org1==============="
docker exec -e "VERSION=4.0" -e "CHANNEL_NAME=mychannel" -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" -e "CORE_PEER_ADDRESS=peer2.org1.example.com:9051" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/ca.crt" cli peer chaincode invoke -n fishcc -C mychannel -c '{"args":["queryFish","FISH0"]}' -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem
echo "============end query chaincode==============="

sleep 5
echo "============record fish peer2org1==============="

docker exec -e "VERSION=4.0" -e "CHANNEL_NAME=mychannel" -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" -e "CORE_PEER_ADDRESS=peer2.org1.example.com:9051" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/ca.crt" cli peer chaincode invoke -n fishcc -C mychannel -c '{"args":["recordFish","FISH10","5","4","3","2","1"]}' -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem
echo "============end record fish==============="


sleep 5
echo "============queryAll chaincode peer2org1==============="
docker exec -e "VERSION=4.0" -e "CHANNEL_NAME=mychannel" -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" -e "CORE_PEER_ADDRESS=peer2.org1.example.com:9051" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/ca.crt" cli peer chaincode invoke -n fishcc -C mychannel -c '{"args":["queryAllFishes","x"]}' -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem
echo "============end queryAll chaincode==============="

sleep 5
echo "============query history peer2org1==============="
docker exec -e "VERSION=4.0" -e "CHANNEL_NAME=mychannel" -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" -e "CORE_PEER_ADDRESS=peer2.org1.example.com:9051" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/ca.crt" cli peer chaincode invoke -n fishcc -C mychannel -c '{"args":["queryHistory","FISH0"]}' -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem
echo "============end query history==============="




echo -e "\n"
echo "npm install 安装依赖文件"
echo "node enrollAdmin.js， 创建管理员，然后执行node registerUser.js创建用户"
echo "node invoke.js, 调用函数"
echo "node query.js, 查询记录"
echo -e "\n"

cd ../webapp-tls
node ./enrollAdmin.js
node ./registerUser.js


