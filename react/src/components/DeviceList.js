import React, { Component } from 'react';
import Device from './Device';
import DeviceLog from './DeviceLog';
import Message from './Message';

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

class DeviceList extends Component {
  constructor(){
    super();
    this.state = {
      devices: [],
      am_devices: [],
      error: undefined
    };
    this.sendSeed = this.sendSeed.bind(this);
    this.sendLightSeed = this.sendLightSeed.bind(this);
  }

  componentDidMount() {
    fetch(__API__ + '/devices').then(result=> {
      result.json().then(json=> this.setState({devices:json["data"]}));
    });

    fetch(__API__ + '/am_devices').then(result=> {
      result.json().then(json=> this.setState({am_devices:json["data"]}));
    });
  }
  sendSeed(event) {
    event.preventDefault();

    fetch(__API__ + '/devices/seed', {
      method: 'post', headers: {'Content-Type':'application/json'}
    }).then(r=> {
      r.json().then(json=> {
        //TODO: verify response code, exception case, etc
        if (json['success']) {
          console.log('success');
          window.location = json['redirect'] || '/';
        } else {
          console.log('fail');
          this.setState({ 'error': json['message']})
        }
    })})
  }
  sendLightSeed(event) {
    event.preventDefault();

    fetch(__API__ + '/devices/light_seed', {
      method: 'post', headers: {'Content-Type':'application/json'}
    }).then(r=> {
      r.json().then(json=> {
        if (json['success']) {
          console.log('success');
          window.location = json['redirect'] || '/';
        } else {
          console.log('fail');
          this.setState({ 'error': json['message']})
        }
    })})
  }
  render() {
    //TODO: make two separate components
    return (
      <div className={"row"}>
        {
          this.state.error && <Message message={this.state.error}/>
        }
        <div className={"col-6"}>
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
