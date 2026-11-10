# Package

version       = "0.1.0"
author        = "litlighilit"
description   = "exception(error) types like Python's"
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim > 2.0.8"

var pylibPre = "https://github.com/nimpylib"
let envVal = getEnv("NIMPYLIB_PKGS_BARE_PREFIX")
if envVal != "": pylibPre = ""
#if pylibPre == Def: pylibPre = ""
elif pylibPre[^1] != '/':
  pylibPre.add '/'
template pylib(x, ver) =
  requires if pylibPre == "": x & ver
           else: pylibPre & x


pylib "pysimperr", " ^= 0.1.0"
pylib "errno", " ^= 0.1.0"
pylib "handy_sugars", " ^= 0.1.0"
pylib "jscompat", " ^= 0.1.11"
pylib "collections_abc", " ^= 0.1.0"
pylib "pyio_abc", " ^= 0.1.0"
pylib "autoconf_sugars", " ^= 0.1.0"

