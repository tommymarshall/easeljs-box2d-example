var gulp = require('gulp');

gulp.task('watch', ['setWatch', 'browserSync'], function() {
	gulp.watch('./source/images/**', ['images']);
	gulp.watch('./source/javascripts/**', ['browserify']);
	gulp.watch('./source/*.html', ['copy']);
});