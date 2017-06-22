import React, { Component } from 'react';

class DeviceLog extends Component {
  constructor(){
    super();
  }

  render() {
    if(this.props.history == null)
    {
      return( 
        <div> </div> 
      )
    }else{
      return(
        <div>
        <h4> Log Events </h4>
        {
          this.props.history.map((device_log,index)=> {
            return(
              <div key={index}>
              <p>Data/hora do evento: {device_log.created_at}</p>
              <p>Situação: {device_log.description}</p>
              <hr/>
              </div>
            )
          })
        }
        </div>
      )
    }
  }
}

export default DeviceLog;
