import React, {Component} from 'react';
import Device from './Device';

import Message from './Message';

import {handleResponse} from '../helpers'

class DeviceListActions extends Component {
  render(){
    return (
        <nav>
          <input type="button" value="FORWARD ALL" onClick={this.props.sendFwAll}/>
          <input type="button" value="RUN COMPLETE" onClick={this.props.sendRunComplete}/>
        </nav>
        )
  }
}

class DeviceList extends Component {
  constructor(){
    super();
    this.state = {
      devices: [],
      error: undefined
    };
    this.sendFwAll = this.sendFwAll.bind(this);
    this.sendRunComplete = this.sendRunComplete.bind(this);
  }

  componentDidMount() {
    const params = window.location.href.split('?')[1];
    const urlParams = params === undefined ? '' : '&'+params;
    fetch(__API__+'/devices'+'?ajax=true'+urlParams).then(result=> handleResponse(result,
          (r) => { this.setState({devices:r.data}) },
          (r) => { this.setState({error: r.message}) }
          ));
  }

  sendFwAll(event) {
    event.preventDefault();

    fetch(__API__+'/devices/forward_all', {
      method: 'post', headers: {'Content-Type':'application/json'}
    }).then(result=> handleResponse(result,
        (r) => { window.location = r.redirect || '/' },
        (r) => { this.setState({error: r.message})}
        ));
  }

  sendRunComplete(event) {
    event.preventDefault();

    fetch(__API__+'/devices/run_complete', {
      method: 'post', headers: {'Content-Type':'application/json'}
    }).then(
      result => handleResponse(result,
        (r) => { window.location = r.redirect || '/' },
        (r) => { this.setState({error: r.message})})
      )
  }

  render() {
      return (
          <div>
          <h3> Lab </h3>
          {
            this.state.error && <Message message={this.state.error} />
          }
          <DeviceListActions sendFwAll={this.sendFwAll} sendRunComplete={this.sendRunComplete}/>
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