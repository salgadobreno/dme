import React, { Component } from 'react';
import DeviceLog from './DeviceLog';
import AmDeviceList from  './AmDeviceList';
import DeviceList from './DeviceList';
import Message from './Message';

class DeviceIndex extends Component {
  constructor(){
    super();
    this.state = {
      error: undefined
    };
  }

  
  render() {
    return (
      <div className={"row"}>
        {
          this.state.error && <Message message={this.state.error}/>
        }

        <div className={"col-6"}> <AmDeviceList/> </div>
        <div className={"col-6"}> <DeviceList/> </div>
      </div>
    );
  }
}

export default DeviceIndex;
