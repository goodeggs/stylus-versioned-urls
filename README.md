stylus-versioned-urls [![NPM version](https://badge.fury.io/js/stylus-versioned-urls.png)](http://badge.fury.io/js/stylus-versioned-urls) [![Build Status](https://travis-ci.org/goodeggs/stylus-versioned-urls.png)](https://travis-ci.org/goodeggs/stylus-versioned-urls)
==============

Stylus plugin to version urls in built css.

This plugin doesn't generate versioned urls, it assumes you've [already done that](https://github.com/theasta/grunt-assets-versioning).  It takes a map of unversioned to versioned urls and translates unversioned urls in the stylus source to versioned urls in the css output.


Installation
------------
```
npm install stylus-versioned-urls
```

Usage
-----
```js
var stylus = require('stylus'),
    versionedUrls = require('stylus-versioned-urls')
    versions = {
      '/fonts/sans.woff': '/fonts/sans.123.woff'
      '/fonts/serif.woff': '/fonts/serif.456.woff'
    };

stylus(css)
  .use(versionedUrls(versions))
  .render(function(err, output) {
    console.log(output)
  })

```

With Grunt
----------
Combine with [grunt-contrib-stylus](https://github.com/gruntjs/grunt-contrib-stylus) and [grunt-assets-versioning](https://github.com/theasta/grunt-assets-versioning) to version and build CSS:

```js
var stylusVersionedUrls = require('stylus-versioned-urls')
grunt.loadNpmTasks('grunt-contrib-stylus')
grunt.loadNpmTasks('grunt-contrib-copy')
grunt.loadNpmTasks('grunt-assets-versioning')

grunt.initConfig({
  versionManifest: {},

  assets_versioning: {
    images: {
      expand: true,
      cwd: 'public/',
      src: ['**/*.jpg', '**/*.png'],
      dest: 'versioned/',
      options: {
        use: 'hash',
        hashLength: 8,
        multitask: 'copy',
        output: 'build/version_manifest.json'
      }
    }
  },

  stylus: {
    all: {
      src: 'src/**/*.styl',
      dest: 'public/css/'
      ext: '.css'
      options: {
        use: [
          function() {
            return stylusVersionedUrls(grunt.config('versionManifest'))
          }
        ]
      }
    }
  }
})

grunt.registerTask('loadVersionManifest', function() {
  var memoryManifest = grunt.config('versionManifest'),
      fileManifest = grunt.file.readJSON('build/versionManifest')
  fileManifest.forEach(function(file) {
    memoryManifest[file.path] = file.revved_path
  })
})

grunt.registerTask('default', [
  'assets_versioning',
  'loadVersionManifest',
  'stylus'
])
```

