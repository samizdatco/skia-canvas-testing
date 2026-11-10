#!/bin/bash
# prints one markdown row per dylib: label, stroff % 8, indirect-symbol count, minos/sdk, and whether dlopen succeeds here
# usage: inspect.sh <label> <dylib>...
label=$1; shift
for f in "$@"; do
  stroff=$(otool -l "$f" | awk '/cmd LC_SYMTAB/{x=1} x&&/stroff/{print $2; exit}')
  nind=$(otool -l "$f" | awk '/cmd LC_DYSYMTAB/{x=1} x&&/nindirectsyms/{print $2; exit}')
  build=$(otool -l "$f" | awk '/cmd LC_BUILD_VERSION/{x=1} x&&/minos/{m=$2} x&&/sdk/{print m"/"$2; exit}')
  load=$(python3 -c 'import ctypes,sys
try: ctypes.CDLL(sys.argv[1]); print("loads")
except OSError as e: print("FAILS: " + str(e).split(":")[-1].strip()[:80])' "$f" 2>&1)
  echo "| $label | $(basename "$f") | $((stroff % 8)) | $nind | $build | $load |"
done
