module.exports = [
  {
    type: "button"
    tooltip: "Make"
    callback: "make:all"
    icon: "cogs"
    iconset: "fa"
  }
  {
    type: "url"
    tooltip: "Open"
    url: "https://typetiny.toby.ink/"
    icon: "globe"
    iconset: "fa"
  }
  {
    type: "function"
    tooltip: "ls -l"
    icon: "list"
    iconset: "fa"
    callback: (target) ->
      fn = target.buffer.file.path
      srv = atom.packages.activePackages['x-terminal'].mainModule.getInstance().providePlatformIOIDEService()
      srv.run( ['ls -l ' + fn ] )
    }
]
