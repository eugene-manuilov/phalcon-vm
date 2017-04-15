const path = require('path');

const webpack = require('webpack');
const ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
	entry: {
		application: path.resolve(__dirname, 'assets/application.js')
	},

	output: {
		path: path.resolve(__dirname, 'public/'),
		publicPath: '/',
		filename: 'application.js'
	},

	module: {
		rules: [
			{
				test: /\.js$/,
				include: path.resolve(__dirname, 'assets'),
				exclude: /node_modules/,
				loader: 'babel-loader',
				query: {
					presets: ["es2015"]
				}
			},
			{
				test: /\.scss$/,
				include: [path.resolve(__dirname, 'assets'), path.resolve(__dirname, 'node_modules')],
				loaders: ExtractTextPlugin.extract({
					fallback: 'style-loader',
					use: 'css-loader?sourceMap!sass-loader?sourceMap'
				})
			}
		]
	},

	plugins: [
		new webpack.NoEmitOnErrorsPlugin()

		, new ExtractTextPlugin({
			filename: '[name].css',
			allChunks: true
		})

		, new webpack.optimize.UglifyJsPlugin({
			compress: {warnings: false},
			output: {comments: false},
			sourceMap: false
		})
	]
};
