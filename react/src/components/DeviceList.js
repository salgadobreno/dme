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
    fetch('http://localhost:8080/devices').then(result=> {
      result.json().then(json=> this.setState({devices:json}));
    });
  }

  render() {
    return (
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
              <Device 
                key={index}
                serial_number={device.serial_number}
                sold_at={device.sold_at}
                warranty_days={device.warranty_days}
                blacklisted={device.blacklisted}
                current_state={device.current_state} />
            )
          })
        }
        </tbody>
      </table>
      </div>
   );
  }
}

export default DeviceList;
