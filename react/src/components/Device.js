import React, { Component } from 'react';
import DeviceLog from './DeviceLog'

class Device extends Component {
  constructor(){
    super();
  }

  render() {
    if(Object.keys(this.props.device).length == 0) {
      return (<div> </div>)
    }else{
      return(
        <div>
          <div>
            <hr/>
            <h4>Device Info</h4>
            SerialNumber: {this.props.device.serial_number}<br />
            SoldAt: {this.props.device.sold_at}<br />
            WarrantyDays: {this.props.device.warranty_days}<br />
            Blacklisted: {this.props.device.blacklisted}<br />
            CurrentState: {this.props.device.current_state}<br />
          </div>
          <DeviceLog history={this.props.device.device_logs}/>
        </div>
      );
    }
  }
}

export default Device;
