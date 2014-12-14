gulp = require 'gulp'
exec = require 'gulp-exec'
through2 = require 'through2'
gistupload = require './upload2gist'

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
  gulp.src 'scripts/*.*'
  .pipe p2g()
  .pipe exec 'gist2image <%= file.url %> ./images/<%= file.name %>.png'

gulp.task 'wait', ->
  gulp.watch './scripts/*.*', ['upload2gist']

gulp.task 'gist2image', ->
  gulp.src 'images/gistlist.json'
  .pipe g2i()


gulp.task 'default', ['compile'], ->
  gulp.src 'main.tex'
  .pipe exec 'open main.pdf'
  .pipe exec.reporter
    err: true
    stderr: true
    stdout: true
  gulp.watch './**/*.tex', ['compile']
  gulp.watch './scripts/*.*', ['upload2gist']
