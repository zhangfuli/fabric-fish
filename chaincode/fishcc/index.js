const shim = require('fabric-shim');
const Chaincode = class {
    //链码初始化操作
    async Init(stub) {
        console.info("====== Instantiated fish chaincode =======");
        return shim.success(Buffer.from('chaincode init successs'));
    }

    async Invoke(stub) {
        let ret = stub.getFunctionAndParameters();
        let method = this[ret.fcn];
        if (!method) {
            return shim.error(Buffer.from('no method of name:' + ret.fcn + ' found'));
        }
        return method(stub, ret.params)
    }

    async initLedger(stub, args) {
        console.info("========= start init ledger ==========");
        let fishes = [];
        fishes.push({
            location: '1.000,2.000',
            timestamp: '1111',
            vessel: '奋进号A',
            temperature: '1',
            holder: '王大壮1',
        });
        fishes.push({
            location: '1.000,2.000',
            timestamp: '1111',
            vessel: '奋进号A',
            temperature: '2',
            holder: '王大壮2',
        });
        fishes.push({
            location: '1.000,2.000',
            timestamp: '1111',
            vessel: '奋进号A',
            temperature: '3',
            holder: '王大壮3',
        });
        fishes.push({
            location: '1.000,2.000',
            timestamp: '1111',
            vessel: '奋进号A',
            temperature: '4',
            holder: '王大壮4',
        });
        for (let i = 0; i < fishes.length; i++) {
            await stub.putState('FISH' + i, Buffer.from(JSON.stringify(fishes[i])));
            console.log('Added FISH: ' + JSON.stringify(fishes[i]))
        }
        return shim.success(Buffer.from("======== Added success!! ========"))
    }

    async recordFish(stub, args) {
        console.log("recordFish");
        if (args.length !== 6) {
            throw new Error("need 6 args:id vessel location timestamp temperature holder");
        }
        let fish = {
            vessel: args[1],
            location: args[2],
            timestamp: args[3],
            temperature: args[4],
            holder: args[5],
        };
        await stub.putState(args[0], Buffer.from(JSON.stringify(fish)))
        return shim.success(Buffer.from("======== record success ========"))
    }

    async queryFish(stub, args) {
        if (args.length !== 1) {
            throw new Error("error with args, for example: FISH01");
        }
        let fish = args[0];
        let fishBytes = await stub.getState(fish);
        if (!fishBytes || fishBytes.toString().length <= 0) {
            throw new Error(fishBytes + ' 不存在')
        }
        let retFish = JSON.parse(fishBytes);
        console.log(retFish);
        return shim.success(Buffer.from(JSON.stringify(retFish)));
    }

    async queryAllFishes(stub, args) {
        let startKey = 'FISH0';
        let endKey = 'FISH999';
        let iterator = await stub.getStateByRange(startKey, endKey);
        let allResults = [];
        while (true) {
            let res = await iterator.next();
            console.log(res);
            if (res.value && res.value.value.toString()) {
                let jsonRes = {};
                console.log(res.value.value.toString('utf8'));

                jsonRes.Key = res.value.key;
                try{
                    jsonRes.Record = JSON.parse(res.value.value.toString('utf8'));
                }catch (err) {
                    console.log(err);
                    jsonRes.Record = res.value.value.toString('utf8');
                }
                allResults.push(jsonRes);
            }
            if(res.done){
                console.log('end of data');
                await iterator.close();
                console.log(JSON.stringify(allResults));
                return shim.success(Buffer.from(JSON.stringify(allResults)));
            }
        }
        return shim.error(Buffer.from("query error"))

    }

    async updateHolder(stub, args) {
        console.log("updateHolder");
        if (args.length !== 2) {
            throw new Error("need 2 args: id, new holder");
        }
        let fishBytes  = await stub.getState(args[0]);
        let fish = JSON.parse(fishBytes);
        fish.holder = args[1];
        await stub.putState(args[0], Buffer.from(JSON.stringify(fish)));
        return shim.success(Buffer.from("success"))
    }

    async queryHistory(stub, args){
        console.log("queryHistory");
        let iterator = await stub.getHistoryForKey(args[0]);
        let allResults = [];
        while (true) {
            let res = await iterator.next();
            console.log(res);
            if (res.value && res.value.value.toString()) {
                let jsonRes = {};
                console.log(res.value.toString('utf8'));

                jsonRes.Key = res.value.key;
                jsonRes.TxId = res.value.txId;
                try{
                    jsonRes.Record = JSON.parse(res.value.value.toString('utf8'));
                }catch (err) {
                    console.log(err);
                    jsonRes.Record = res.value.value.toString('utf8');
                }
                allResults.push(jsonRes);
            }
            if(res.done){
                console.log('end of data');
                await iterator.close();
                console.log(JSON.stringify(allResults));
                return shim.success(Buffer.from(JSON.stringify(allResults)));
            }
        }
        return shim.error(Buffer.from("query error"))
    }

};
shim.start(new Chaincode());
