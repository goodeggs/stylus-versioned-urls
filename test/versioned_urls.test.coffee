assert = require 'assert'
stylus = require 'stylus'
versionedUrls = require '..'

describe 'versioned-urls', ->

  describe 'given a map of unversioned to versioned paths', ->
    manifest =
      '/img/beep.png': '/img/beep.123.png'

    it 'transforms unversioned urls in source files to verisoned urls in output', (done) ->
      stylus("""
      .robot
        background-image url('/img/beep.png')
      """)
      .use(versionedUrls manifest)
      .render (err, output) ->
        return done(err) if err
        assert.equal output, """
        .robot {
          background-image: url('/img/beep.123.png');
        }\n
        """
        done()

    it 'errors on unmapped urls', (done) ->
      stylus("""
      .robot
        background-image url('/img/bop.png')
      """)
      .use(versionedUrls manifest)
      .render (err, output) ->
        assert(/No versioned path/.test err.message)
        done()

    it 'ignores data: urls', (done) ->
      stylus("""
      .robot
        background-image url('data:/img/beep.png')
      """)
      .use(versionedUrls manifest)
      .render (err, output) ->
        return done(err) if err
        assert.equal output, """
        .robot {
          background-image: url('data:/img/beep.png');
        }\n
        """
        done()

    it 'preserves querystrings from source but doesnt use them for versioned path lookup', (done) ->
      stylus("""
      .robot
        background-image url('/img/beep.png?foo=bar')
      """)
      .use(versionedUrls manifest)
      .render (err, output) ->
        return done(err) if err
        assert.equal output, """
        .robot {
          background-image: url('/img/beep.123.png?foo=bar');
        }\n
        """
        done()


