import React, { Component } from 'react';

class Device extends Component {
  constructor(){
    super();
  }

  render() {
    return(
      <div>
        <h4>Device Info</h4>
        SerialNumber: {this.props.serial_number}<br />
        SoldAt: {this.props.sold_at}<br />
        WarrantyDays: {this.props.warranty_days}<br />
        Blacklisted: {this.props.blacklisted}<br />
        CurrentState: {this.props.current_state}<br />
      </div>
    );
  }
}

export default Device;
