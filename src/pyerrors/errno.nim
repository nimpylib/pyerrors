
when defined(js):
  template errno*: cint{.error: "use getErrno of pkg/errno".} = 0
elif defined(windows):
  # std/posix has defined `errno`
  var errno*{.importc, header: "<errno.h>".}: cint
else:
  import std/posix
  export errno
