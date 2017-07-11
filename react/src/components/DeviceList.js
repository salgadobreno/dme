import React, { Component } from 'react';
import Device from './Device';
import DeviceLog from './DeviceLog';
import Message from './Message';

class DeviceList extends Component {
  constructor(){
    super();
    this.state = {
      devices: [],
      am_devices: [],
      error: undefined
    };
  }

  componentDidMount() {
    fetch(__API__ + '/devices').then(result=> {
      result.json().then(json=> this.setState({devices:json["data"]}));
    });

    fetch(__API__ + '/am_devices').then(result=> {
      result.json().then(json=> this.setState({am_devices:json["data"]}));
    });
  }

  render() {
    //TODO: make two separate components
    return (
      <div className={"row"}>
        {
          this.state.error && <Message message={this.state.error}/>
        }
        <div className={"col-6"}>
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
        </div>
        <div className={"col-6"}>
          <table>
            <caption>
              <h3> Lab </h3>
            </caption>
            <thead>
              <tr>
                <th> Serial Number </th>
                <th> Current State </th>
                <th colSpan="2"> Actions </th>
              </tr>
            </thead>
            <tbody>
            {
              this.state.devices.map((device,index)=> {
                return(
                    <tr key={index}>
                    <td> {device.serial_number} </td>
                    <td> {device.current_state} </td>
                    <td> <a href={"/devices/" + device.serial_number}>SHOW</a></td>
                    </tr>
                    )
              })
            }
            </tbody>
          </table>
        </div>
        <hr/>
      </div>
    );
  }
}

export default DeviceList;
