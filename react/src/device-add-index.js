import React, { Component } from 'react';
import { render } from 'react-dom';

//payload input component
class PayloadInput extends Component {
  constructor(){
    super();
    //this.addInput = this.addInput.bind(this);
    //this.handleChange = this.handleChange.bind(this);
  }

  addInput(){
    this.setState({
      payload: this.state.payload.concat([["",""]])
    });
  }

  //handleChange(event){
    //const target = event.target;
    //const value = target.value;
    //const name = target.name;

    //this.setState({
      //[name]: value
    //})
  //}

  render() {
    return (
      <div>
        {
          Object.keys(this.props.value).map((key, i)=> {
            return <div key={'div-'+i}>
              <input  name="payload[][key]" type="text" value={key} />
              :
              <input  name="payload[][value]" type="text" value={this.props.value[key]} />
            </div>
          })
        }
        <div>
          <input type="button" value="+" onClick={this.addInput}/>
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
      payload: {
        key1:"value1",
        key2:"value2"
      }
    };

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(event){
    console.log(this.state);
    event.preventDefault();
  }

  handleChange(event){
    const target = event.target;
    const value = target.value;
    const name = target.name;

    this.setState({
      [name]: value
    })
  }

  render(){
    return (
      <form onSubmit={this.handleSubmit}>
        <input type="number" name="id" onChange={this.handleChange} value={this.state.id}/>
        <label>
          Serial Number:
          <input type="text" name="serial_number" onChange={this.handleChange} value={this.state.serial_number}/>
        </label>
        <PayloadInput value={this.state.payload}/>
        <input type="submit" value="Submit"/>
      </form>
    )
  }
}

render(<AddDevice />, document.getElementById('root'));
