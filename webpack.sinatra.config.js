const config = require('./webpack.config.js');
const webpack = require('webpack');

config.plugins.unshift(
  new webpack.DefinePlugin({
    'process.env': {
      'NODE_ENV': JSON.stringify('production')
    },
    '__API__': JSON.stringify("http://localhost:4567")
  })
);

module.exports = config;
