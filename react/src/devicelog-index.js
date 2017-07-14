import React, { Component } from 'react';
import { render } from 'react-dom';
import Message from './components/Message';

import DevicePrompt from './components/DevicePrompt';
import DeviceLog from './components/DeviceLog';

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
    fetch(__API__ + '/devices/' + this.state.serial_number + '/device_logs').then(result=> {
      result.json().then(json=> {
        if (json['success']) {
          console.log('success');
          this.setState({device_log:json['data']})
        } else {
          console.log('fail');
          this.setState({ 'error': json['message']})
        }
    })})
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
