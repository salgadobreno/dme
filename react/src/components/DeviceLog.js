import React, { Component } from 'react';

class DeviceLog extends Component {
  handleShow() {
    alert('Tell me your story');
  }
  render() {
    return(
    <div>
      <button onClick={this.handleShow} >DeviceLog</button>
    </div>
    );
  }
}

export default DeviceLog;
