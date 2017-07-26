import React, { Component } from 'react';
import { render } from 'react-dom';
import Message from './components/Message';

import DevicePrompt from './components/DevicePrompt';
import Device from './components/Device';

class DeviceActions extends Component {
  render() {
    const r = Object.keys(this.props.device).length == 0 ? (<div></div>) : (<div>
        <input value="FORWARD" type="button" onClick={this.props.handleForward}/>
        <input value="REMOVE" type="button" onClick={this.props.handleRemove}/>
        <input value="FULL HISTORY" type="button" onClick={this.props.handleShowHistory}/>
      </div>);
    return r;
  }
}

class DeviceShow extends Component {
  constructor(){
    super();
    this.state = {
      serial_number: "",
      device: {},
      error: undefined
    }
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.handleForward = this.handleForward.bind(this);
    this.handleRemove = this.handleRemove.bind(this);
    this.handleShowHistory = this.handleShowHistory.bind(this);

    const path = window.location.pathname.split('/');
    const id = path[path.length - 1];
    if (!(id === undefined) && !(isNaN(id))) {
      this.state["serial_number"] = id;
      this.handleSubmit();
    }
  }

  handleForward(){
    fetch(__API__+'/devices/'+this.state.serial_number+'/forward', {
      method: 'post', headers: {'Content-Type':'application/json'}
    }).then(r=> {
      //TODO: verify response code, exception case, etc in r
      r.json().then(json=> {
        console.log("response: ");
        console.log(json);
        if (json['success']) {
          console.log('success');
          window.location = json['redirect'] || '/';
        } else {
          console.log('fail');
          this.setState({ 'error': json['message']})
        }
    })})
  }

  handleRemove(){
    fetch(__API__+'/devices/'+this.state.serial_number, {
      method: 'delete', headers: {'Content-Type':'application/json'}
    }).then(r=> {
      //TODO: verify response code, exception case, etc in r
      r.json().then(json=> {
        console.log("response: ");
        console.log(json);
        if (json['success']) {
          console.log('success');
          window.location = json['redirect'] || '/';
        } else {
          console.log('fail');
          this.setState({ 'error': json['message']})
        }
    })})
  }

  handleShowHistory(){
    window.location = '/devices/show_log/' + this.state.serial_number;
  }

  handleSubmit(event){
    if (!(event === undefined)) {
      event.preventDefault();
    }

    const device = {};
    fetch(__API__+'/devices/'+this.state.serial_number+'?ajax=true').then(result=> {
      result.json().then(json=> {
        if (json['success']) {
          console.log('success');
          this.setState({device:json['data']})
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
        <DeviceActions device={this.state.device} handleForward={this.handleForward} handleRemove={this.handleRemove} handleShowHistory={this.handleShowHistory}/>
        <Device device={this.state.device}/>
      </div>
    )
  }
}

render(<DeviceShow />, document.getElementById('root'));
