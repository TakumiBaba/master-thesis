Github = require 'github'
Loki   = require 'lokijs'
config = require './package.json'
DBPATH = "#{__dirname}/.#{config.name}.json"

AA = module.exports = (filename, contents, cb) ->
  db = new Loki DBPATH

  initialize = (callback) ->
    if (require('fs').existsSync(DBPATH))
      db.loadDatabase (serialized) ->
        db.loadJSON serialized
        callback()
    else
      callback()
  save = (url) ->
    db.save (err) ->
      cb err, {name: filename, url: url}

  initialize ->
    github = new Github
      version: '3.0.0'

    github.authenticate
      type: 'basic'
      username: process.env.GITHUB_USERNAME
      password: process.env.GITHUB_PASSWORD

    create = (filename, contents) ->
      msg =
        public: true
        files: {}
      msg.files["#{filename}"] = content: contents
      github.gists.create msg, (err, result) ->
        gists.insert {gid: result.id, filename: filename}
        save result.html_url

    gists = null
    for collection in db.listCollections()
      if collection.name is 'gists'
        gists = db.getCollection 'gists'
    if !gists?
      gists = db.addCollection 'gists'
    gist = gists.findOne filename: filename
    if gist.length is 0
      create filename, contents
    else
      gid = gist.gid
      msg =
        id: gid
        files: {}
      msg.files[filename] = content: contents
      github.gists.edit msg, (err, result) ->
        if !err?
          save result.html_url
        else
          create filename, contents
