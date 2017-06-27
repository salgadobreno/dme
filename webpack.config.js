const webpack = require('webpack');
const path = require('path');

module.exports = {
  entry: {
    items: './react/src/index',
    myapp: './react/src/myappindex',
    devicelist: './react/src/device-list-index.js',
    deviceadd: './react/src/device-add-index.js'
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
    hot: true
  },
  plugins: [
    new webpack.optimize.OccurrenceOrderPlugin(),
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoEmitOnErrorsPlugin(),
    new webpack.DefinePlugin({
      '__API__': JSON.stringify("http://localhost:8080")
    })
  ]
};
