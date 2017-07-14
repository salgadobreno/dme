const webpack = require('webpack');
const path = require('path');

module.exports = {
  entry: {
    device: './react/src/device-index.js',
    devicelog: './react/src/devicelog-index.js',
    devicelist: './react/src/device-list-index.js',
    deviceadd: './react/src/device-add-index.js',
    myapp: './react/src/myappindex',
    items: './react/src/index',
  },
  module: {
    loaders: [
      { test: /\.js?$/, loader: 'babel-loader', exclude: /node_modules/ },
      { test: /\.s?css$/, loader: 'style-loader!css-loader!sass-loader' },
    ]
  },
  resolve: {
    extensions: ['.js','.scss']
  },
  output: {
    path: path.join(__dirname, '/app/web/public'),
    filename: '[name]-bundle.js'
  },
  devtool: 'cheap-eval-source-map',
  devServer: {
    contentBase: './react/views/',
    disableHostCheck: true,
    hot: true,
    historyApiFallback: {
      index: 'devicelist.html',
      rewrites: [
        {from: /\/devices\/new/, to: '/deviceadd.html'},
        {from: /\/devices\/\d+/, to: '/device.html'},
        {from: /\/devices\/show_log/, to: '/device_log.html'},
        {from: /\/devices\/show/, to: '/device.html'},
        {from: /\/devices/, to: '/devicelist.html'},
        {from: '/', to: '/devicelist.html'},
      ]
    }
  },
  plugins: [
    new webpack.optimize.OccurrenceOrderPlugin(),
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoEmitOnErrorsPlugin(),
    new webpack.DefinePlugin({
      '__API__': typeof process.env['__API__'] === 'undefined' ? JSON.stringify("http://localhost:8080") : JSON.stringify(process.env['__API__'])
    })
  ]
};
