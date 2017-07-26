import React, {Component} from 'react';
import Device from './Device';
import Message from './Message';

class DeviceListActions extends Component {
  render(){
    return (
        <nav>
          <input type="button" value="FORWARD ALL" onClick={this.props.sendFwAll}/>
          <input type="button" value="RUN COMPLETE" onClick={this.props.sendRunComplete}/>
        </nav>
        )
  }
}

class DeviceList extends Component {
  constructor(){
    super();
    this.state = {
      devices: [],
      error: undefined
    };
    this.sendFwAll = this.sendFwAll.bind(this);
    this.sendRunComplete = this.sendRunComplete.bind(this);
  }

  componentDidMount() {
    const params = window.location.href.split('?')[1];
    const urlParams = params === undefined ? '' : '?'+params;
    fetch(__API__ + '/devices'+urlParams).then(result=> {
      result.json().then(json=> {
        if (json['success']) {
          console.log('success');
          this.setState({devices:json["data"]})
        } else {
          console.log('fail');
          this.setState({ 'error': json['message']})
        }
      });
    });
  }

  sendFwAll(event) {
    event.preventDefault();

    fetch(__API__ + '/devices/forward_all', {
      method: 'post', headers: {'Content-Type':'application/json'}
    }).then(r=> {
      r.json().then(json=> {
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

  sendRunComplete(event) {
    event.preventDefault();

    fetch(__API__ + '/devices/run_complete', {
      method: 'post', headers: {'Content-Type':'application/json'}
    }).then(r=> {
      r.json().then(json=> {
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

  render() {
      return (
          <div>
          <h3> Lab </h3>
          {
            this.state.error && <Message message={this.state.error} />
          }
          <DeviceListActions sendFwAll={this.sendFwAll} sendRunComplete={this.sendRunComplete}/>
          <table>
          <thead>
          <tr>
          <th> Serial Number </th>
          <th> Current State </th>
          <th colSpan="2"> Actions </th>
          </tr>
          </thead>
          <tbody>
          {
            this.state.devices.map((device,index)=> {
              return(
                  <tr key={index}>
                  <td> {device.serial_number} </td>
                  <td> {device.current_state} </td>
                  <td> <a href={"/devices/" + device.serial_number}>SHOW</a></td>
                  </tr>
                  )
            })
          }
      </tbody>
        </table>
        </div>
      )
  }
}
export default DeviceList;
