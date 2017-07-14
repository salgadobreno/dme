import React, { Component } from 'react';
import { render } from 'react-dom';

import DeviceList from './components/DeviceList';

class DeviceListIndex extends Component {
  render(){
    return (
        <div className={"row"}>
          { /*<div className={"col-6"}> <AmDeviceList/> </div>*/ }
          <DeviceList/>
        </div>
        )
  }
}

render(<DeviceListIndex/>, document.getElementById('root'));
