import React, { Component } from 'react';
import Device from './Device';
import DeviceLog from './DeviceLog';

class DeviceList extends Component {
  constructor(){
    super();
    this.state = {
      devices: [],
      currentDevice: {},
      showDetails: false,
      showHistory: false
    };

    this.handleShowDetails = this.handleShowDetails.bind(this);
    this.handleShowHistory = this.handleShowHistory.bind(this);
  }

  componentDidMount() {
    fetch('http://localhost:8080/devices').then(result=> {
      result.json().then(json=> this.setState({devices:json}));
    });
  }

  handleShowDetails(device) {
    this.setState(
      {
        currentDevice: device,
        showDetails: !this.state.showDetails
      }
    )
  }

  handleShowHistory(device) {
    this.setState(
      {
        currentDevice: device,
        showHistory: !this.state.showHistory
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
                <td> <button onClick={this.handleShowDetails.bind(this, device)}>Details {this.state.showDetails? '(-)': '(+)'} </button> </td>
                <td> <button onClick={this.handleShowHistory.bind(this, device)}>History {this.state.showHistory? '(-)': '(+)'} </button> </td>
              </tr>
            )
          })
        }
        </tbody>
      </table>
      </div>
      <div>
      {
        this.state.showDetails &&
        <Device
          serial_number={this.state.currentDevice.serial_number}
          sold_at={this.state.currentDevice.sold_at}
          warranty_days={this.state.currentDevice.warranty_days}
          blacklisted={this.state.currentDevice.blacklisted}
          current_state={this.state.currentDevice.current_state}
          />
      }
      </div>
      <hr/>
      <div>
      {
        this.state.showHistory &&
        <DeviceLog history={this.state.currentDevice.device_logs} />
      }
      </div>

      </div>
   );
  }
}

export default DeviceList;
