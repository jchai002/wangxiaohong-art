var gulp = require('gulp'),
    sass = require('gulp-sass'),
    sourcemaps = require('gulp-sourcemaps'),
    autoprefixer = require('gulp-autoprefixer'),
    minify = require('gulp-minify-css'),
    concat = require('gulp-concat'),
    rename = require('gulp-rename');

var scssSource = './assets/scss/';
var jsSource = './assets/js/source/';
var jsDest = './assets/js/dest/';

gulp.task('build-css', function() {
  console.log('buidling css..')
  gulp.src(scssSource + 'main.scss')
    .pipe(sourcemaps.init())
    .pipe(sass().on('error', sass.logError))
    .pipe(autoprefixer({
      browsers: ['last 25 versions']
    }))
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest('./assets/css'))
});

gulp.task('build-js', function() {
gulp.src([jsSource+'jQuery/*',jsSource+'core/tether.min.js',jsSource+'core/bootstrap.min.js',jsSource+'plugin/**/*',jsSource+'custom/**/*'])
.pipe(concat('main.js'))
.pipe(gulp.dest(jsDest));
});

gulp.task('watch', function(){
  gulp.watch(scssSource+ '**/*.scss', ['build-css']);
  // gulp.watch(jsSource +'**/*',['build-js']);
});

gulp.task('default', ['build-css', 'watch']);
