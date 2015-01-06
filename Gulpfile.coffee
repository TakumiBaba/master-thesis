gulp = require 'gulp'
exec = require 'gulp-exec'
through2 = require 'through2'
gistupload = require './upload2gist'
gaze = require 'gaze'
pandoc = require 'gulp-pandoc'
gm = require 'gulp-gm'

gulp.task 'compile', ->
  gulp.src "main.tex"
  .pipe exec 'platex  -kanji=utf8 main'
  .pipe exec 'pbibtex -kanji=utf8 main'
  .pipe exec.reporter
    err: true
    stderr: true
    stdout: true
  .pipe exec 'platex  -kanji=utf8 main'
  .pipe exec.reporter
    err: true
    stderr: true
    stdout: true
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

# gulp.task 'upload2gist', ->
#   gaze 'scripts/*.*', (err, watcher) ->
#     upload = (filepath) ->
#       paths = filepath.split '/'
#       # 対処療法につきすぐ直す
#       return if paths[paths.length-2] isnt 'scripts'
#       gulp.src filepath
#       .pipe p2g()
#       .pipe exec 'gist2image <%= file.url %> ./images/<%= file.name %>.png'
#       .pipe exec 'convert ./images/<%= file.name %>.png ./images/<%= file.name %>.eps'
#     @on "changed", upload
#     @on "added", upload

gulp.task 'image_reset', ->
  gulp.src 'main.tex'
  .pipe exec 'rm .master_thesis.json'
  .pipe exec 'rm -r images'
  .pipe exec 'mkdir images'

gulp.task 'md2tex', ->
  gaze './markdown/*.md', (err, watcher) ->
    @on "changed", (filepath) ->
      console.log 'md2tex'
      console.log filepath
      gulp.src filepath
      .pipe pandoc
        from: 'markdown'
        to: 'latex'
        ext: '.tex'
        args: ['--chapters', '--listings']
      .pipe gulp.dest 'tex/'
  return gulp.src 'markdown/*.md'
  .pipe pandoc
    from: 'markdown'
    to: 'latex'
    ext: '.tex'
    args: ['--chapters', '--listings']
  .pipe gulp.dest 'tex/'

gulp.task 'image2eps', () ->
  gulp.watch 'images/*.png', (file) ->
    console.log file.path
    func = (f) ->
      return f.setFormat 'eps'
    gulp.src file.path
    # .pipe exec 'convert <$'
    .pipe gm func, {imageMagick: true}
    .pipe gulp.dest 'images/'
  # gulp.src 'images/*.png'
  # .pipe exec 'echo <%= file.name %>'
  # gaze './images/*.png', (err, watcher) ->
  #   @on "changed", (filepath) ->
  #     gulp.src filepath
  #     .pipe gm (file) ->
  #       return gm.setFormat 'eps'
  #     .pipe gulp.dest 'images/'


gulp.task 'default', ['md2tex', 'compile'], ->
  gulp.src 'main.tex'
  .pipe exec 'open main.pdf'
  .pipe exec.reporter
    err: true
    stderr: true
    stdout: true
  gulp.watch './**/*.tex', ['compile']
  # gulp.watch 'images/*.png', ['image2eps']
