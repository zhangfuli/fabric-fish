'use strict';


//通过链码查询

var Fabric_Client = require('fabric-client');
var path = require('path');
var util = require('util');
var os = require('os');
var fs = require('fs');


var fabric_client = new Fabric_Client();

//var firstnetwork_path = path.resolve('..', 'fish-network');
//var org1tlscacert_path = path.resolve(firstnetwork_path, 'crypto-config', 'peerOrganizations', 'org1.example.com', 'tlsca', 'tlsca.org1.example.com-cert.pem');
//var org1tlscacert = fs.readFileSync(org1tlscacert_path, 'utf8');

var channel = fabric_client.newChannel('mychannel');
var peer = fabric_client.newPeer('grpc://localhost:7051');
//var peer = fabric_client.newPeer('grpcs://localhost:7051', {
//	'ssl-target-name-override': 'peer0.org1.example.com',
//	pem: org1tlscacert
//});
channel.addPeer(peer);


var member_user = null;
var store_path = path.join(__dirname, 'hfc-key-store');
console.log('Store path:' + store_path);
var tx_id = null;


var query = async (chaincodeId, fcn, args) => {
    try {
        var state_store = await Fabric_Client.newDefaultKeyValueStore({path: store_path});
        fabric_client.setStateStore(state_store);
        var crypto_suite = Fabric_Client.newCryptoSuite();

        var crypto_store = Fabric_Client.newCryptoKeyStore({path: store_path});
        crypto_suite.setCryptoKeyStore(crypto_store);
        fabric_client.setCryptoSuite(crypto_suite);
        var user_from_store = await fabric_client.getUserContext('user1', true)
        if (user_from_store && user_from_store.isEnrolled()) {
            console.log('Successfully loaded user1 from persistence');
            member_user = user_from_store;
        } else {
            throw new Error('Failed to get user1.... run registerUser.js');
        }

        //更改这里
        const request = {
            chaincodeId: chaincodeId,
            fcn: fcn,
            args: args
        };

        var query_responses = await channel.queryByChaincode(request);
        console.log("Query has completed, checking results");
        console.log(query_responses)

        if (query_responses && query_responses.length == 1) {
            if (query_responses[0] instanceof Error) {
                console.error("error from query = ", query_responses[0]);
                return "error from query = " + query_responses[0]
            } else {
                console.log("Response is ", query_responses[0].toString());
                return query_responses[0].toString()
            }
        } else {
            console.log("No payloads were returned from query");
            return "No payloads were returned from query"
        }
    } catch (err) {
        console.error('Failed to query successfully :: ' + err);
        return 'Failed to query successfully :: ' + err
    }
};

module.exports = query;


