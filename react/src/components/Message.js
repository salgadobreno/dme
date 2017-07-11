import React, { Component } from 'react';

class Message extends Component {
  constructor(props){
    super(props);
  }

  render(){
    return (
      <div>{this.props.message}</div>
    )
  }
}

export default Message;
