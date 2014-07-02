var browserify   = require('browserify');
var watchify     = require('watchify');
var bundleLogger = require('../util/bundleLogger');
var gulp         = require('gulp');
var handleErrors = require('../util/handleErrors');
var source       = require('vinyl-source-stream');

gulp.task('browserify', function() {
	var bundleMethod = global.isWatching ? watchify : browserify;

	var bundler = bundleMethod({
		entries: ['./source/javascripts/game.coffee'],
		extensions: ['.coffee']
	});

	var bundle = function() {
		bundleLogger.start();

		return bundler
			.bundle({debug: true})
			.on('error', handleErrors)
			.pipe(source('compiled.js'))
			.pipe(gulp.dest('./build'))
			.on('end', bundleLogger.end);
	};

	if (global.isWatching) {
		bundler.on('update', bundle);
	}

	return bundle();
});