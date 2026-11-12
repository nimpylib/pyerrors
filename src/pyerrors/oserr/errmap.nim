
import std/tables
export tables

import pkg/errno/errnoConsts
import pkg/errno/private/varIfJs
import ./types

when defined(js):
  {.pragma: ErrnoMapAttr.}
else:
  #import ../../pyconfig/util
  when defined(wasm):
    # NIM-BUG: WASM backend won't remain the symbol of compileTime till runtime
    {.pragma: ErrnoMapAttr.}
  else:
    {.pragma: ErrnoMapAttr, compileTime.}

{.pragma: OSErrorInitAttrs, nimcall, noSideEffect.}

var errnomap*{.ErrnoMapAttr.}: Table[cint, proc(): ref PyOSError{.OSErrorInitAttrs.}]
proc default_oserror*(): ref PyOSError{.OSErrorInitAttrs.} =
  new PyOSError

template ifdef(err; body) =
  if_var Errno.err in ValidErrnos:
    body

when true: # PyExc_InitState
    template ADD_ERRNO(exc, err){.dirty.} =
     errnomap[err] = proc(): ref PyOSError = new exc
# The following is just copied from CPython's PyExc_InitState AS-IS.

    ADD_ERRNO(BlockingIOError, EAGAIN);
    ADD_ERRNO(BlockingIOError, EALREADY);
    ADD_ERRNO(BlockingIOError, EINPROGRESS);
    ADD_ERRNO(BlockingIOError, EWOULDBLOCK);
    ADD_ERRNO(BrokenPipeError, EPIPE);
    ifdef ESHUTDOWN:
      ADD_ERRNO(BrokenPipeError, ESHUTDOWN);
    ADD_ERRNO(ChildProcessError, ECHILD);
    ADD_ERRNO(ConnectionAbortedError, ECONNABORTED);
    ADD_ERRNO(ConnectionRefusedError, ECONNREFUSED);
    ADD_ERRNO(ConnectionResetError, ECONNRESET);
    ADD_ERRNO(FileExistsError, EEXIST);
    ADD_ERRNO(FileNotFoundError, ENOENT);
    ADD_ERRNO(IsADirectoryError, EISDIR);
    ADD_ERRNO(NotADirectoryError, ENOTDIR);
    ADD_ERRNO(InterruptedError, EINTR);
    ADD_ERRNO(PermissionError, EACCES);
    ADD_ERRNO(PermissionError, EPERM);
    ifdef ENOTCAPABLE:
      # Extension for WASI capability-based security. Process lacks
      # capability to access a resource.
      ADD_ERRNO(PermissionError, ENOTCAPABLE);
    ADD_ERRNO(ProcessLookupError, ESRCH);
    ADD_ERRNO(TimeoutError, ETIMEDOUT);

    #TODO:WSA
    #ifdef WSAETIMEDOUT:
    #  ADD_ERRNO(TimeoutError, WSAETIMEDOUT);

