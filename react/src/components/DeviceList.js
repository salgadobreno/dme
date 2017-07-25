import React, {Component} from 'react';
import Device from './Device';

class DeviceList extends Component {
  constructor(){
    super();
    this.state = {
      devices: []
    };
  }

  componentDidMount() {
    fetch(__API__+'/devices'+'?ajax=true').then(result=> {
      result.json().then(json=> this.setState({devices:json["data"]}));
    });
  }
  render() {
      return (
          <div>
            <h3> Lab </h3>
            <table>
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
      )
  }
}
export default DeviceList;
