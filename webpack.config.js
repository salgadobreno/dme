const webpack = require('webpack');
const path = require('path');

module.exports = {
  entry: {
    items: './react/src/index',
    myapp: './react/src/myappindex'
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
    contentBase: './app/web/views/',
    hot: true
  },
  plugins: [
    new webpack.optimize.OccurrenceOrderPlugin(),
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoEmitOnErrorsPlugin()
  ]
};
