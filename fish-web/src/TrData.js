import React, {Component} from 'react';

class TrData extends Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            this.props.fishes.map((fish, i) => {
                return (
                    <tr className="text-center">
                        <td>{fish.id}</td>
                        <td>{fish.holder}</td>
                        <td>{fish.location}</td>
                        <td>{fish.temperature} 摄氏度</td>
                        <td>{fish.vessel}</td>
                        <td>{fish.time}</td>
                    </tr>
                )
            })
        )
    }
}

export default TrData;