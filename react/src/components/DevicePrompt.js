import React, { Component } from 'react';
import { render } from 'react-dom';

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

export default DevicePrompt;
