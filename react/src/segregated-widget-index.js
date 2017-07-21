import React, { Component } from 'react';
import { render } from 'react-dom';

class SegregatedWidget extends Component {
  constructor(){
    super();
    this.state = {
      devices: [
        {
          serial_number: '00000',
          previous_state: 'triage',
          current_state: 'segregated'
        }
      ]
    }
  }

  componentDidMount() {
    fetch(__API__ + '/devices/segregated_overview').then(result=> {
      result.json().then(json=> this.setState({devices:json["data"]}));
    });
  }

  render() {
    return (
        <div className={"row border"}>
          <table>
            <thead>
              <tr>
                <th>SerialNumber</th>
                <th>PreviousState</th>
                <th>CurrentState</th>
              </tr>
            </thead>
            <tbody>
              {
                this.state.devices.map((device, index)=> {
                  return (
                      <tr key={index}>
                        <td>{device.serial_number}</td>
                        <td>{device.previous_state}</td>
                        <td>{device.current_state}</td>
                      </tr>
                      )
                })
              }
            </tbody>
          </table>
        </div>
        );
  }
}

render(<SegregatedWidget />, document.getElementById('segregated-widget-root'));
