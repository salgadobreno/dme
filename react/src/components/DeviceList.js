import React, { Component } from 'react';
import Device from './Device';

class DeviceList extends Component {
  constructor(){
    super();
    this.state = {
      devices: []
    };
  }

  componentDidMount() {
    fetch(process.env.API_URL + '/devices').then(result=> {
      result.json().then(json=> this.setState({devices:json}));
    });
  }

  render() {
    return (
      <div>
      <div>Devices:</div>
      {
        this.state.devices.map(device=> {
          return <Device
          serial_number={device.serial_number}
          sold_at={device.sold_at}
          warranty_days={device.warranty_days}
          blacklisted={device.blacklisted}
          current_state={device.current_state}
            />
        })
      }
      </div>
    );
  }
}

export default DeviceList;
