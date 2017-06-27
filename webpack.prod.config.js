const config = require('./webpack.config.js');
const webpack = require('webpack');

//NOTE: I'm using `unshift` here since it seems when it's searching and replacing
//for the strings the order matters, not sure it's the best solution but we`ll go
//with this for the moment.
config.plugins.unshift(
  new webpack.DefinePlugin({
    'process.env': {
      'NODE_ENV': JSON.stringify('production')
    },
    '__API__': JSON.stringify("http://192.168.2.5:8080")
    //'__API__': JSON.stringify("http://localhost:4567")
    //'__API__': JSON.stringify("http://192.168.1.53:4567")
  })
);

config.plugins.push(
  new webpack.optimize.UglifyJsPlugin({
    compress: {
      warnings: false
    }
  })
);

module.exports = config;
