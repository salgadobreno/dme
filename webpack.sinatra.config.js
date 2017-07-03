const config = require('./webpack.config.js');
const webpack = require('webpack');

config.plugins.unshift(
  new webpack.DefinePlugin({
    'process.env': {
      'NODE_ENV': JSON.stringify('production')
    },
    '__API__': typeof process.env['__API__'] === 'undefined' ? JSON.stringify("http://localhost:4567") : JSON.stringify(process.env['__API__'])
  })
);

module.exports = config;
