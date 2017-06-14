import React, { Component } from 'react';

class Device extends Component {
  constructor(){
    super();
  }

  render() {
    return (
      <div>
        <div>
        Serial Number: {this.props.serial_number}
        </div>
        <div>
        Solt at: {this.props.sold_at}
        </div>
        <div>
        Warranty Days: {this.props.warranty_days}
        </div>
        <div>
        Blacklisted?: {String(this.props.blacklisted)}
        </div>
        <div>
        Current State: {this.props.current_state}
        </div>
        <hr/>
      </div>
    );
  }
}

export default Device;
