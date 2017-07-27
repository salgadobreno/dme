import React, { Component } from 'react';
import { render } from 'react-dom';
import Message from './components/Message';

import DevicePrompt from './components/DevicePrompt';
import DeviceLog from './components/DeviceLog';

import {handleResponse} from './helpers'

class DeviceHistory extends Component {
  constructor(){
    super();
    this.state = {
      serial_number: "",
      device_log: null,
      error: undefined
    }
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);

    const path = window.location.pathname.split('/');
    const id = path[path.length - 1];
    if (!(id === undefined) && !(isNaN(id))) {
      this.state["serial_number"] = id;
      this.handleSubmit();
    }
  }

  handleSubmit(event){
    if (!(event === undefined)) {
      event.preventDefault();
    }

    const device = {};
    fetch(__API__ + '/devices/' + this.state.serial_number + '/device_logs').then(result=>
        handleResponse(result,
          (r)=> { this.setState({device_log:r.data}) },
          (r)=> { this.setState({error: r.message}) }))
  }

  handleChange(event){
    const target = event.target;
    const value = target.value;
    const name = target.name;
    this.setState({
      [name]: value
    })
  }

  render() {
    return (
      <div>
        {
          this.state.error && <Message message={this.state.error}/>
        }
        <DevicePrompt handleSubmit={this.handleSubmit} handleChange={this.handleChange} serial_number={this.state.serial_number}/>
        <DeviceLog history={this.state.device_log}/>
      </div>
    )
  }
}

render(<DeviceHistory />, document.getElementById('root'));
