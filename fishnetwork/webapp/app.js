const express = require('express');
const app = express();
const query = require("./query");
const invoke = require("./invoke");
var bodyParser = require('body-parser');
const port = 3000;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));


//解决跨域
app.all('*',function (req, res, next) {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Content-Type, Content-Length, Authorization, Accept, X-Requested-With');
    res.header('Access-Control-Allow-Methods', 'PUT, POST, GET, DELETE, OPTIONS');
    if (req.method === 'OPTIONS') {
        res.send(200);
    }
    else {
        next();
    }
});

app.get('/queryAllFishes', async (req, res) => res.send(await query("fishcc","queryAllFishes",new Array("x"))));
app.get('/queryFish', async (req, res) => res.send(
    await query("fishcc", "queryFish", new Array(req.query.fish))
));
app.get('/queryHistory', async (req, res) => res.send(
    await query("fishcc", "queryHistory", new Array(req.query.fish))
));


/*
*  channel:mychannel
*  chaincode:fishcc
*  fcn:updateHolder
*  fish:FISH0
*  holder:1111
*/
app.post("/updateHolder", async (req, res)=>{
    res.send(await invoke(req.body.channel, req.body.chaincode, req.body.fcn, [req.body.fish, req.body.holder]))
});
app.post("/recordFish", async (req, res)=>{
    console.log(req.body)
    res.send(
        await invoke(req.body.channel, req.body.chaincode, req.body.fcn,
            [req.body.fish,  req.body.vessel, req.body.location, req.body.timestamp, req.body.temperature, req.body.holder]
        ));
});

app.listen(port, () => console.log(`Example app listening on port ${port}!`));