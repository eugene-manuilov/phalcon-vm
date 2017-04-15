const path = require('path');
const webpack = require('webpack');

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
				loader: 'style-loader!css-loader?sourceMap!sass-loader?sourceMap'
			}
		]
	},

	plugins: [
		new webpack.NoEmitOnErrorsPlugin()

		, new webpack.optimize.UglifyJsPlugin({
			compress: {warnings: false},
			output: {comments: false},
			sourceMap: false
		})
	]
};
