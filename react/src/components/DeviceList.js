import React, { Component } from 'react';
import Device from './Device';
import DeviceLog from './DeviceLog';

class DeviceList extends Component {
  constructor(){
    super();
    this.state = {
      devices: [],
      currentDevice: {
      }
    };

    this.handleShowDevice = this.handleShowDevice.bind(this);
  }

  componentDidMount() {
    fetch('http://localhost:8080/devices').then(result=> {
      result.json().then(json=> this.setState({devices:json}));
    });
  }

  handleShowDevice(device) {
    this.setState(
      {
        currentDevice: device
      }
    )
  }
  render() {
    return (
      <div>
      <div>
      <table>
       <caption>
        <h3> Devices </h3>
       </caption>

        <thead>
          <tr>
            <th> Serial Number </th>
            <th> Current State </th>
            <th colSpan="2"> Actions </th>
          </tr>
        </thead>
        <tbody>
        {
          this.state.devices.map((device,index)=> {
            return(
              <tr key={index}>
                <td> {device.serial_number} </td>
                <td> {device.current_state} </td>
                <td> <button onClick={this.handleShowDevice.bind(this, device)}>ShowInfo </button> </td>
                <td> <button>ShowLog</button> </td>
              </tr>
            )
          })
        }
        </tbody>
      </table>
      </div>
      <div>
        <Device
          serial_number={this.state.currentDevice.serial_number}
          sold_at={this.state.currentDevice.sold_at}
          warranty_days={this.state.currentDevice.warranty_days}
          blacklisted={this.state.currentDevice.blacklisted}
          current_state={this.state.currentDevice.current_state}
          />
      </div>
      <hr/>
      <div>
          <DeviceLog history={this.state.currentDevice.device_logs} />
      </div>

      </div>
   );
  }
}

export default DeviceList;
