import React, { Component } from 'react';
import DeviceCard from './DeviceCard';
import DeviceLog from './DeviceLog';

class Device extends Component {
  constructor(){
    super();
  }

  render() {
    return(
        <tr>
          <td> {this.props.serial_number} </td>
          <td> {this.props.current_state} </td>
          <td> <DeviceCard /> </td>
          <td> <DeviceLog /> </td>
        </tr>
    );
  }
}

export default Device;
