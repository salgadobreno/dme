const config = require('./webpack.config.js');
const webpack = require('webpack');

//NOTE: I'm using `unshift` here since it seems when it's searching and replacing
//for the strings the order matters, not sure it's the best solution but we`ll go
//with this for the moment.
config.plugins.unshift(
  new webpack.DefinePlugin({
    'process.env': {
      'NODE_ENV': JSON.stringify('production')
    }
  })
);

config.plugins.unshift(
  new webpack.DefinePlugin({
    '__API__': typeof process.env['__API__'] === 'undefined' ? JSON.stringify("http://192.168.2.5:8080") :JSON.stringify(process.env['__API__'])
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
