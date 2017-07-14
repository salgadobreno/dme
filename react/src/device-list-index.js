import React, { Component } from 'react';
import { render } from 'react-dom';

import AmDeviceList from './components/AmDeviceList';
import DeviceList from './components/DeviceList';

class DeviceListIndex extends Component {
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

export default DeviceListIndex


render(<DeviceListIndex />, document.getElementById('root'));
