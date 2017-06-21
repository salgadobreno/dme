import React, { Component } from 'react';

class DeviceCard extends Component {
  handleShow() {
    alert('check it out');
  }
  render() {
    return(
    <div>
      <button onClick={this.handleShow} >ShowInfo</button>
    </div>
    );
  }
}

export default DeviceCard;
