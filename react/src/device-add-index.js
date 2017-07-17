import React, { Component } from 'react';
import { render } from 'react-dom';
import Message from './components/Message';

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
      serial_number: "",
      payload: [
        ["",""],
        ["",""]
      ],
      error: undefined
    };

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handlePayloadChange = this.handlePayloadChange.bind(this);
    this.removePayloadItem = this.removePayloadItem.bind(this);
    this.addPayloadItem = this.addPayloadItem.bind(this);

    const path = window.location.pathname.split('/');
    const id = path[path.length - 1];
    if (!(id === undefined) && !(isNaN(id))) {
      this.state["serial_number"] = id;
    }
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

    //convert the bidimensional payload array into payload object
    var obj = {}
    this.state.payload.forEach(function(data) {
      obj[data[0]] = data[1];
    });
    const stateClone = {
      serial_number: this.state.serial_number,
      payload: obj
    };
    const jsonParams = JSON.stringify(stateClone);

    fetch(__API__+'/devices', {
      method: 'post', body:jsonParams, headers: {'Content-Type':'application/json'}
    }).then(r=> {
      r.json().then(json=> {
        console.log("response: ");
        console.log(json);
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
        {
          this.state.error && <Message message={this.state.error} />
        }
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
