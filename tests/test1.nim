
import std/unittest

import pkg/errno
import pyerrors
test "types":
  check declared(PyOSError)

test "__new__":
  check newPyOSError(ENOENT, "") of FileNotFoundError

