import React, { Component } from 'react';
import { render } from 'react-dom';

//payload input component
class PayloadInput extends Component {
  constructor(props){
    super(props);
  }

  render() {
    const inputs = this.props.payload.map((arr, i)=> {
      return (
        <div key={i}>
          <input type="text" value={arr[0]} onChange={this.props.payloadOnChange.bind(this, i, 0)} />
          :
          <input type="text" value={arr[1]} onChange={this.props.payloadOnChange.bind(this, i, 1)} />
          <input type="button" value="-" onClick={this.props.removePayload.bind(this, i)}/>
        </div>
    )
    });
    return (
      <div>
        { inputs }
        <div>
          <input type="button" value="+" onClick={this.props.addPayloadItem}/>
        </div>
      </div>
    )
  }
}

//device-add component
class AddDevice extends Component {
  constructor(){
    super();
    this.state = {
      id: "",
      serial_number: "",
      payload: [
        ["",""],
        ["",""]
      ]
    };

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handlePayloadChange = this.handlePayloadChange.bind(this);
    this.removePayloadItem = this.removePayloadItem.bind(this);
    this.addPayloadItem = this.addPayloadItem.bind(this);
  }

  addPayloadItem(){
    this.setState({
      payload: this.state.payload.concat([["",""]])
    });
  }

  removePayloadItem(index){
    const newPayload = this.state.payload.slice();
    newPayload.splice(index, 1);
    this.setState({
      payload: newPayload
    })
  }

  handleSubmit(event){
    event.preventDefault();

    const jsonParams = JSON.stringify(this.state);

    fetch(process.env.API_URL + '/devices', {method: 'post', body:jsonParams, headers: {'Content-Type':'application/json'},}).then(r=> {
      console.log("response: ");
      console.log(r);
      //TODO: verify response code, exception case, etc
      window.location = "/device-list-index.html";
    })
  }

  handleChange(event){
    const target = event.target;
    const value = target.value;
    const name = target.name;
    this.setState({
      [name]: value
    })
  }

  handlePayloadChange(index, kv, event){
    const newPayload = this.state.payload.slice();
    const modifiedItem = newPayload[index];
    modifiedItem[kv] = event.target.value;
    this.setState({
      payload: newPayload
    })
  }

  render(){
    return (
      <form onSubmit={this.handleSubmit}>
        <label>
          Serial Number:
          <input type="text" name="serial_number" onChange={this.handleChange} value={this.state.serial_number}/>
        </label>
        <PayloadInput payload={this.state.payload} addPayloadItem={this.addPayloadItem} payloadOnChange={this.handlePayloadChange} removePayload={this.removePayloadItem} />
        <input type="submit" value="Submit"/>
      </form>
    )
  }
}

render(<AddDevice />, document.getElementById('root'));
