import React, {Component} from 'react';
import {Container, Row, Col, Form, Button, Table, InputGroup, FormControl} from 'react-bootstrap';
import 'bootstrap/dist/css/bootstrap.min.css';
import './App.css';
import Axios from "axios";
import TrData from "./TrData";

class App extends Component {
    // eslint-disable-next-line no-useless-constructor
    constructor(props) {
        super(props);
        this.state = {
            fishes: [],
            historyId: 'FISH0',
            history: [],
            newFish: {
                fish: 'FISH6',
                holder: '晓庄',
                location: '2.0000,4.0000',
                temperature: '22',
                vessel: '黑珍珠号',
                timestamp: '2020-02-02',
                channel: 'mychannel',
                chaincode: 'fishcc',
                fcn: 'recordFish'
            },
            newHolder: {
                fish: 'FISH0',
                holder: '吃鱼吧',
                channel: 'mychannel',
                chaincode: 'fishcc',
                fcn: 'updateHolder'
            }
        }

    }

    componentDidMount() {
        this.getAllFishes();
        this.getHistory();
    }

    getAllFishes() {
        let self = this;
        Axios.get('http://39.106.189.16:3000/queryAllFishes')
            .then(function (response) {
                let fishes = [];
                for (let i = 0; i < response.data.length; i++) {
                    let fish = {
                        id: response.data[i].Key,
                        holder: response.data[i].Record.holder,
                        location: response.data[i].Record.location,
                        temperature: response.data[i].Record.temperature,
                        vessel: response.data[i].Record.vessel,
                        time: response.data[i].Record.timestamp
                    };
                    fishes.push(fish)

                }
                self.setState({
                    fishes: fishes
                });
            })
            .catch(function (error) {
                console.log(error);
            })
    }

    getHistory() {
        let self = this;
        Axios.get('http://39.106.189.16:3000/queryHistory?fish=' + self.state.historyId)
            .then(function (response) {
                let fishes = [];
                for (let i = 0; i < response.data.length; i++) {
                    let fish = {
                        id: response.data[i].TxId,
                        holder: response.data[i].Record.holder,
                        location: response.data[i].Record.location,
                        temperature: response.data[i].Record.temperature,
                        vessel: response.data[i].Record.vessel,
                        time: response.data[i].Record.timestamp
                    };
                    fishes.push(fish)

                }
                self.setState({
                    history: fishes
                });
            })
            .catch(function (error) {
                console.log(error);
            })
    }

    recordFish() {
        let self = this;
        Axios.post('http://39.106.189.16:3000/recordFish', self.state.newFish)
            .then(function (response) {
                alert('提交成功');
                self.getAllFishes();
                self.setState({
                    historyId: self.state.newFish.fish
                });
                self.getHistory()
            })
            .catch(function (error) {
                console.log(error);
            })
    }

    updateHolder() {
        let self = this;
        Axios.post('http://39.106.189.16:3000/updateHolder', self.state.newHolder)
            .then(function (response) {
                alert('提交成功');
                self.getAllFishes();
                self.setState({
                    historyId: self.state.newFish.fish
                });
                self.getHistory()
            })
            .catch(function (error) {
                console.log(error);
            })
    }

    handleRecordChange(key, e) {
        let newFish = this.state.newFish;
        newFish[key] = e.target.value;
        this.setState({
            newFish: newFish
        });
    }

    handleUpdateChange(key, e) {
        let newHolder = this.state.newHolder;
        newHolder[key] = e.target.value;
        this.setState({
            newHolder: newHolder
        });
    }

    searchChange(e) {
        this.setState({
            historyId: e.target.value
        })
    }

    refreshAll() {
        this.getAllFishes()
    }

    searchHistory() {
        this.getHistory()
    }

    render() {
        return (
            <div className="">
                <Container>
                    <Row>
                        <Col>
                            当前状态 &nbsp;&nbsp;&nbsp;&nbsp;
                            <Button variant="primary" onClick={this.refreshAll.bind(this)}>
                                refresh
                            </Button>
                            <Table striped bordered hover>
                                <thead>
                                <tr>
                                    <th>Fish id</th>
                                    <th>Holder</th>
                                    <th>Location</th>
                                    <th>Temperature</th>
                                    <th>Vessel</th>
                                    <th>Time</th>
                                </tr>
                                </thead>
                                <tbody>
                                <TrData fishes={this.state.fishes}/>
                                </tbody>

                            </Table>
                        </Col>
                        <Col>
                            <InputGroup className="mb-3">
                                <FormControl
                                    placeholder="Username"
                                    value={this.state.historyId}
                                    onChange={this.searchChange.bind(this)}
                                />
                                <Button variant="primary"
                                        onClick={this.searchHistory.bind(this)}>
                                    search
                                </Button>
                            </InputGroup>
                            <Table striped bordered hover>
                                <thead>
                                <tr>
                                    <th>Tx id</th>
                                    <th>Holder</th>
                                    <th>Location</th>
                                    <th>Temperature</th>
                                    <th>Vessel</th>
                                    <th>Time</th>
                                </tr>
                                </thead>
                                <tbody>
                                <TrData fishes={this.state.history}/>
                                </tbody>
                            </Table>
                        </Col>
                    </Row>
                    <Row>
                        <Col>
                            <Form>
                                <Form.Group controlId="formFishId">
                                    <Form.Label>Fish id</Form.Label>
                                    <Form.Control type="text" placeholder="Enter fish id--FISH00"
                                                  value={this.state.newFish.fish}
                                                  onChange={this.handleRecordChange.bind(this, 'fish')}/>
                                    <Form.Text className="text-muted">
                                        用于记录哪一批次的鱼
                                    </Form.Text>
                                </Form.Group>

                                <Form.Group controlId="formHolder">
                                    <Form.Label>Holder</Form.Label>
                                    <Form.Control type="text" placeholder="fish holder"
                                                  value={this.state.newFish.holder}
                                                  onChange={this.handleRecordChange.bind(this, 'holder')}/>
                                    <Form.Text className="text-muted">
                                        鱼的所有者
                                    </Form.Text>
                                </Form.Group>

                                <Form.Group controlId="formLocation">
                                    <Form.Label>Location</Form.Label>
                                    <Form.Control type="text" placeholder="fish location---1.000, 2.00"
                                                  value={this.state.newFish.location}
                                                  onChange={this.handleRecordChange.bind(this, 'location')}/>
                                    <Form.Text className="text-muted">
                                        鱼的捕捞位置
                                    </Form.Text>
                                </Form.Group>

                                <Form.Group controlId="formTemperature">
                                    <Form.Label>Temperature</Form.Label>
                                    <Form.Control type="text" placeholder="fish temperature"
                                                  value={this.state.newFish.temperature}
                                                  onChange={this.handleRecordChange.bind(this, 'temperature')}/>
                                    <Form.Text className="text-muted">
                                        鱼的捕捞温度
                                    </Form.Text>
                                </Form.Group>

                                <Form.Group controlId="formVessel">
                                    <Form.Label>Vessel</Form.Label>
                                    <Form.Control type="text" placeholder="fish vessel"
                                                  value={this.state.newFish.vessel}
                                                  onChange={this.handleRecordChange.bind(this, 'vessel')}/>
                                    <Form.Text className="text-muted">
                                        鱼的捕捞船只
                                    </Form.Text>
                                </Form.Group>

                                <Form.Group controlId="formTimestamp">
                                    <Form.Label>Timestamp</Form.Label>
                                    <Form.Control type="text" placeholder="Time---2020.02.02"
                                                  value={this.state.newFish.timestamp}
                                                  onChange={this.handleRecordChange.bind(this, 'timestamp')}/>
                                    <Form.Text className="text-muted">
                                        鱼的捕捞时间
                                    </Form.Text>
                                </Form.Group>


                                <Button variant="primary" onClick={this.recordFish.bind(this)}>
                                    Submit
                                </Button>
                            </Form>
                        </Col>
                        <Col>
                            <Form>
                                <Form.Group controlId="formFishId">
                                    <Form.Label>Fish id</Form.Label>
                                    <Form.Control type="text" placeholder="Enter fish id--FISH00"
                                                  value={this.state.newHolder.fish}
                                                  onChange={this.handleUpdateChange.bind(this, 'fish')}/>
                                    <Form.Text className="text-muted">
                                        用于记录哪一批次的鱼
                                    </Form.Text>

                                </Form.Group>

                                <Form.Group controlId="formHolder">
                                    <Form.Label>Holder</Form.Label>
                                    <Form.Control type="text" placeholder="fish holder"
                                                  value={this.state.newHolder.holder}
                                                  onChange={this.handleUpdateChange.bind(this, 'holder')}/>
                                    <Form.Text className="text-muted">
                                        鱼的所有者
                                    </Form.Text>
                                </Form.Group>


                                <Button variant="primary" onClick={this.updateHolder.bind(this)}>
                                    Submit
                                </Button>
                            </Form>
                        </Col>
                    </Row>
                </Container>
            </div>
        );
    }
}


export default App;
