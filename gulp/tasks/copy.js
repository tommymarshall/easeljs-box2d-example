var gulp = require('gulp');

gulp.task('copy', function() {
	return gulp.src('./source/*.html')
		.pipe(gulp.dest('build'));
});