import React from 'react';
import ReactDOM from 'react-dom';
//import registerServiceWorker from './registerServiceWorker';
//import './index.css';

var people = [
  {
    name: "Breno",
    avatar: "https://trello-avatars.s3.amazonaws.com/5fb87e93b13d8c2e627f6de8d64d493e/170.png",
    id: 0
  },
  {
    name: "Edu",
    avatar: "https://trello-avatars.s3.amazonaws.com/3686ffeb0dbbd410c264bfbd5ae8984a/170.png",
    id: 1
  },
  {
    name: "Aline",
    avatar: "https://trello-avatars.s3.amazonaws.com/2e54831225cd27e165b47fbc5b76ae7a/170.png",
    id: 2
  }
];
const Card = React.createClass({
  render: function() {
    return (
      <div>
        <h2>{this.props.name}</h2>
        <img src={this.props.avatar} alt=""/>
        <div></div>
        <button onClick={this.props.onClick}>Delete Me</button>
      </div>
    )
  }
})
const App = React.createClass({
  deletePerson: function(person) {
    this.state.people.splice(this.state.people.indexOf(person), 1);

    this.setState({people: this.state.people});
  },
  getInitialState: function() {
    return {
      people: this.props.people.splice(0)
    }
  },
  render: function() {
    var that = this;
    return (
      <div>
      {
        this.state.people.map(function(person) {
          return (
            <Card name={person.name} avatar={person.avatar} onClick={that.deletePerson.bind(null, person)}/>
          )
        })
      }
      </div>
    )
  }
})

ReactDOM.render(<App people={people}/>, document.getElementById('root'));
registerServiceWorker();
