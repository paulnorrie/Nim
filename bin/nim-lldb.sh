#!/usr/bin/env bash

# Exit if anything fails
set -e

which nim > /dev/null || (echo "nim not in PATH"; exit 1)
which lldb  > /dev/null || (echo "lldb not in PATH"; exit 1)
if [[ "$(uname -s)" == "Darwin" ]]; then
  which greadlink > /dev/null || (echo "greadlink not in PATH. Please install coreutils from brew if on Mac."; exit 1)
else
  which readlink > /dev/null || (echo "readlink not in PATH"; exit 1)
fi

if [[ "$(uname -s)" == "Darwin" ]]; then 
  NIM_SYSROOT=$(dirname $(dirname $(greadlink -f $(which nim))))
elif [["(uname -s)" == *"BSD" ]]; then
  NIM_SYSROOT=$(dirname $(dirname $(readlink -f $(which nim))))
else
  NIM_SYSROOT=$(dirname $(dirname $(readlink -e $(which nim))))
fi

# Find out where the pretty printer Python module is
LLDB_PYTHON_MODULE_PATH="$NIM_SYSROOT/tools/nimlldb.py"

# Run LLDB with the additional arguments that load the pretty printers
exec "$(which lldb)" --one-line-before-file "command script import $LLDB_PYTHON_MODULE_PATH" "$@"
