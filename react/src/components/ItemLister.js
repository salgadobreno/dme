import React, { Component } from 'react';

class ItemLister extends Component {
  constructor(){
    super();
    this.state = { items: [
      "teste1",
      "teste2",
    ] };

    this.activateLasers = this.activateLasers.bind(this);
  }

  componentDidMount() {
    fetch('http://localhost:8080/items').then(result=> {
      result.json().then(json=> this.setState({items:json}));
    });
  }

  activateLasers(){
    this.componentDidMount();
    //fetch('http://localhost:4567/items').then(result=> {
      //result.json().then(json=> this.setState({items:json}));
    //});
  }

  render() {
    return (
      <div>
        <div>Items:</div>
        {
          this.state.items.map(item=> { return <div>{item}</div>})
        }
        <div>
          <button onClick={this.activateLasers}>
            Activate Lazers
          </button>
        </div>
      </div>
    );
  }
}

export default ItemLister;
