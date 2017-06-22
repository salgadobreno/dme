import React, { Component } from 'react';

class DeviceLog extends Component {
  constructor(){
    super();
  }
  render() {
    return(
    <div>
      <h4> Log Events </h4>
      {JSON.stringify(this.props.history)}
    </div>
    );
  }
}

export default DeviceLog;
