assert = require 'assert'
stylus = require 'stylus'
versionedUrls = require '..'

describe 'versioned-urls', ->

  describe 'given a map of unversioned to versioned paths', ->
    manifest =
      '/img/beep.png': '/img/beep.123.png'

    src = """
    .robot
      background-image url('/img/beep.png')
    """

    it 'transforms unversioned paths in source files to verisoned paths in output', (done) ->
      stylus(src).use(versionedUrls manifest).render (err, output) ->
        return done(err) if err
        assert.equal output, """
        .robot {
          background-image: url('/img/beep.123.png');
        }\n
        """
        done()
