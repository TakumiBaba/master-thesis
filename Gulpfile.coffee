gulp = require 'gulp'
exec = require 'gulp-exec'
through2 = require 'through2'
gistupload = require './upload2gist'
gaze = require 'gaze'

gulp.task 'compile', ->
  gulp.src "main.tex"
  .pipe exec 'platex  -kanji=utf8 main'
  .pipe exec 'pbibtex -kanji=utf8 main'
  .pipe exec 'platex  -kanji=utf8 main'
  .pipe exec 'platex  -kanji=utf8 main'
  .pipe exec 'dvipdfmx -p a4 main'
  .pipe exec.reporter
    err: true
    stderr: true
    stdout: true

gulp.task 'clean', ->
  list = '*~ *.log *.dvi *.blg *.aux *.out *.bbl *.lot *.toc *.lof *.pdf'
  gulp.src 'main.pdf'
  .pipe exec "rm -f #{list}"
  .pipe exec.reporter
    err: true
    stderr: true
    stdout: true

gulp.task 'count', ->
  gulp.src 'main.pdf'
  .pipe exec 'ruby ./count.rb --no-tags | tw --pipe'
  .pipe exec.reporter
    err: true
    stderr: true
    stdout: true

gulp.task 'push', ->
  gulp.src 'main.pdf'
  .pipe exec 'git push origin master'
  .pipe exec 'ruby ./count.rb --no-tags | tw --pipe'
  .pipe exec.reporter
    err: true
    stderr: true
    stdout: true

p2g = ->
  return through2.obj (file, encode, callback) ->
    filename = file.relative
    contents = String file.contents
    gistupload filename, contents, (err, data) =>
      @push data
      callback null

gulp.task 'upload2gist', ->
  gaze './scripts/*.*', (err, watcher) ->
    upload = (filepath) ->
      gulp.src filepath
      .pipe p2g()
      .pipe exec 'gist2image <%= file.url %> ./images/<%= file.name %>.png'
    @on "changed", upload
    @on "added", upload

gulp.task 'image_reset', ->
  gulp.src 'main.tex'
  .pipe exec 'rm .master_thesis.json'
  .pipe exec 'rm -r images'
  .pipe exec 'mkdir images'

gulp.task 'default', ['compile', 'upload2gist'], ->
  gulp.src 'main.tex'
  .pipe exec 'open main.pdf'
  .pipe exec.reporter
    err: true
    stderr: true
    stdout: true
  gulp.watch './**/*.tex', ['compile']
