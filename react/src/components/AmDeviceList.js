import React, { Component } from 'react';

class AmDeviceList extends Component {
  constructor(){
    super();
    this.state = {
      am_devices: []
    }
  }

  componentDidMount() {
    fetch(__API__ + '/am_devices').then(result=> {
      result.json().then(json=> this.setState({am_devices:json["data"]}));
    });
  }

  render() {
    if(Object.keys(this.state.am_devices).length == 0) {
      return (<div> </div>)
    }else{
      return (
        <table>
          <caption>
             <h3> Asset Manager </h3>
          </caption>
          <thead>
            <tr>
              <th> Serial Number </th>
            </tr>
          </thead>
          <tbody>
          {
            this.state.am_devices.map((am_device,index)=> {
              return(
                <tr key={'am'+index}>
                  <td> {am_device.serial_number} </td>
                </tr>
              )
            })
          }
          </tbody>
        </table>
      )
    }
  }
}

export default AmDeviceList;
