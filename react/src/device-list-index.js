import React, { Component } from 'react';
import { render } from 'react-dom';

import AmDeviceList from './components/AmDeviceList';
import DeviceList from './components/DeviceList';

class DeviceListIndex extends Component {
  render() {
    return (
      <div className={"row"}>
        <div className={"col-6"}> <AmDeviceList/> </div>
        <div className={"col-6"}> <DeviceList/> </div>
      </div>
    );
  }
}

render(<DeviceListIndex />, document.getElementById('root'));
