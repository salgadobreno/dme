import React, { Component } from 'react';
import { render } from 'react-dom';

//import DevicePrompt from './components/DeviceList';
import Device from './components/Device';
class DevicePrompt extends Component {
  render() {
    return (
      <form onSubmit={this.props.handleSubmit}>
        <label>
          <input type="text" name="serial_number" onChange={this.props.handleChange} value={this.props.serial_number}/>
        </label>
        <input type="submit" value="Search"/>
      </form>
    )
  }
}

class DeviceActions extends Component {
  render() {
    const r = Object.keys(this.props.device).length == 0 ? (<div></div>) : (<div>
        <input value="FORWARD" type="button" onClick={this.props.handleForward}/>
        <input value="REMOVE" type="button" onClick={this.props.handleRemove}/>
      </div>);
    return r;
  }
}

class DeviceShow extends Component {
  constructor(){
    super();
    this.state = {
      serial_number: "",
      device: {}
    }
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.handleForward = this.handleForward.bind(this);
    this.handleRemove = this.handleRemove.bind(this);

    const id = window.location.pathname.split('/')[2];
    if (!(id === undefined) && !(isNaN(id))) {
      this.state["serial_number"] = id;
      this.handleSubmit();
    }
  }
  handleForward(){
    fetch(__API__ + '/devices/' + this.state.serial_number + '/forward', {
      method: 'post', headers: {'Content-Type':'application/json'}
    }).then(r=> {
      console.log("response: ");
      console.log(r);
      //TODO: verify response code, exception case, etc
      window.location = "/devices";
    })
  }
  handleRemove(){
    fetch(__API__ + '/devices/' + this.state.serial_number, {
      method: 'delete', headers: {'Content-Type':'application/json'}
    }).then(r=> {
      console.log("response: ");
      console.log(r);
      //TODO: verify response code, exception case, etc
      window.location = "/devices";
    })
  }
  handleSubmit(event){
    if (!(event === undefined)) {
      event.preventDefault();
    }

    const device = {};
    fetch(__API__ + '/devices/' + this.state.serial_number).then(result=> {
      result.json().then(json=> this.setState({device:json}));
    });
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
        <DevicePrompt handleSubmit={this.handleSubmit} handleChange={this.handleChange} serial_number={this.state.serial_number}/>
        <DeviceActions device={this.state.device} handleForward={this.handleForward} handleRemove={this.handleRemove}/>
        <Device device={this.state.device}/>
      </div>
    )
  }
}

render(<DeviceShow />, document.getElementById('root'));
