import React, { Component } from 'react';

import {handleResponse} from '../helpers'

class AmDeviceListActions extends Component {
  render(){
    return (
        <nav>
          <input type="button" value="SEED" onClick={this.props.sendSeed}/>
          <input type="button" value="LIGHT SEED" onClick={this.props.sendLightSeed}/>
        </nav>
        )
  }
}


class AmDeviceList extends Component {
  constructor(){
    super();
    this.state = {
      am_devices: []
    }
    this.sendSeed = this.sendSeed.bind(this);
    this.sendLightSeed = this.sendLightSeed.bind(this);
  }

  componentDidMount() {
    fetch(__API__ + '/am_devices').then(result=> {
      result.json().then(json=> this.setState({am_devices:json["data"]}));
    });
  }

  sendSeed(event) {
    event.preventDefault();

    fetch(__API__ + '/devices/seed', {
      method: 'post', headers: {'Content-Type':'application/json'}
    }).then(result=> handleResponse(result,
        (r)=> { window.location = r.redirect || '/'},
        (r)=> { this.setState({error: r.message}) }
        ))
  }

  sendLightSeed(event) {
    event.preventDefault();

    fetch(__API__ + '/devices/light_seed', {
      method: 'post', headers: {'Content-Type':'application/json'}
    }).then(result=> handleResponse(result,
        (r)=> { window.location = r.redirect || '/' },
        (r)=> { this.setState({error: r.message}) }
        ))
  }

  render() {
      return (
          <div>
          <h3> Asset Manager </h3>
          <AmDeviceListActions sendSeed={this.sendSeed} sendLightSeed={this.sendLightSeed}/>
          <table>
            <thead>
              <tr>
                <th> Serial Number </th>
                <th> Actions </th>
              </tr>
            </thead>
            <tbody>
            {
              this.state.am_devices.map((am_device,index)=> {
                return(
                    <tr key={'am'+index}>
                      <td> {am_device.serial_number} </td>
                      <td> <a href={"/devices/new/" + am_device.serial_number}>ADD</a></td>
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

export default AmDeviceList;
