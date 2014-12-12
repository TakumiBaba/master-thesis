gulp = require 'gulp'
exec = require 'gulp-exec'

gulp.task 'compile', ->
  gulp.src "main.tex"
  .pipe exec 'platex  -kanji=utf8 main'
  .pipe exec 'pbibtex -kanji=utf8 main'
  .pipe exec 'platex  -kanji=utf8 main'
  .pipe exec 'platex  -kanji=utf8 main'
  .pipe exec 'dvipdfmx -p a4 main'
  .pipe exec 'open main.pdf'
  .pipe exec.reporter
    err: true
    stderr: true
    stdout: true

gulp.task 'clean', ->
  gulp.src 'main.pdf'
  .pipe exec 'rm -f *~ *.log *.dvi *.blg *.aux *.out *.bbl *.lot *.toc *.lof *.pdf'
  .pipe  exec.reporter
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

gulp.task 'default', ['compile'], ->
  gulp.watch './**/*.tex', ['compile']
