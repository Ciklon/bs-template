fs = require 'fs'
gulp = require 'gulp'
plugins = require('gulp-load-plugins')()

cssConfig = (require './css.conf.coffee').config;
jsConfig = (require './js.conf.coffee').config

globalConfig = {
  'browsers': [
    "last 2 versions"
    "IE 10"
  ]
};

gulp.task 'build.js', ->
  return gulp.src jsConfig.files, {cwd: jsConfig.path.src}
#    .pipe plugins.srcmaps.init()
    .pipe plugins.concat
      path: 'main.min.js'
     .pipe plugins.uglify()
#     .pipe plugins.srcmaps.write jsManifest.srcmaps.dest
    .pipe gulp.dest jsConfig.path.dest


gulp.task 'build.copyJsLibs', ->
  return gulp.src jsConfig.libs
    .pipe gulp.dest jsConfig.path.dest

gulp.task 'build.css', ->
  return gulp.src cssConfig.files, {cwd: cssConfig.path.src}
#    .pipe plugins.concat()
    .pipe plugins.less()
    .pipe plugins.autoprefixer
      browsers: globalConfig.browsers
      cascade: false
    .pipe plugins.csso()
    .pipe plugins.rename
      suffix: '.min'
    .pipe gulp.dest cssConfig.path.dest

gulp.task 'build.pages', ->
  return gulp.src 'src/*.jade'
    .pipe plugins.jade({pretty: true})
    .pipe gulp.dest 'dist'

gulp.task 'build.fonts', ->
  return gulp.src 'node_modules/bootstrap/dist/fonts/*'
    .pipe gulp.dest 'dist/fonts/'

gulp.task 'deploy', [
  'build.css',
  'build.pages',
  'build.fonts',
  'build.copyJsLibs',
  'build.js'
]


gulp.task 'watch', ['deploy'], ->
  gulp.watch 'src/styles/**/*.less', ['build.css']
  gulp.watch 'src/**/*.jade', ['build.pages']
  gulp.watch 'src/**/*.js', ['build.js']
  return
