import React, { Component } from 'react';
import { render } from 'react-dom';

class OverviewWidget extends Component {
  constructor(){
    super();
    this.state = {
      states: {
        acceptance:0,
        triage:0,
        maintenance:0,
        qa:0,
        expedition:0,
      }
    }
  }

  componentDidMount() {
    fetch(__API__ + '/devices/overview').then(result=> {
      result.json().then(json=> this.setState({states:json["data"]}));
    });
  }

  render() {
    const r = Object.keys(this.state.states).map((key,index)=> {
      return (
          <div key={index} className={"col-2 border"}>
            <p>{this.state.states[key]}</p>
            {key}
          </div>
          );
    })
    return (
        <div className={"row border"}>
          {r}
        </div>
        );
  }
}

render(<OverviewWidget />, document.getElementById('overview-widget-root'));
