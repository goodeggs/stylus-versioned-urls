module.exports = function(manifest) {
  var URL = require('url')

  return function(stylus) {
    stylus.define('url', function(node) {
      var url = URL.parse(node.val || ''),
          versionedPath
      if (url.protocol !== 'data:') {
        versionedPath = manifest[url.pathname]
        if (!versionedPath)
          throw new Error("No versioned path for " + url.pathname)
        url.pathname = versionedPath
      }
      return new stylus.nodes.Literal("url('" + URL.format(url) + "')")
    })
  }
}
