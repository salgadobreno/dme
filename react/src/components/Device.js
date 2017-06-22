import React, { Component } from 'react';

class Device extends Component {
  constructor(){
    super();
  }

  render() {
    if(this.props.serial_number == null) {
      return (<div> </div>)
    }else{
      return(
        <div>
          <hr/>
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
}

export default Device;
