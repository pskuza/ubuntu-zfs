alias docker-compose=docker-compose-1.10.0.sh
alias d=d.sh
alias g=git
alias zl="sudo zfs list -oname,lused,usedds,usedchild,usedsnap,used,avail,refer,mountpoint,mounted,canmount"
alias zll="sudo zfs list -oname,dedup,compress,compressratio,checksum,sync,quota,copies,atime,devices,exec,rdonly,setuid,xattr,acltype,aclinherit"
alias zls="sudo zfs list -t snap -oname,used,avail,refer"
alias zpl="sudo zpool list -oname,size,alloc,free,cap,dedup,health,frag,ashift,freeing,expandsz,expand,replace,readonly,altroot"
alias zs="sudo zpool status"
alias zio="sudo zpool iostat"
# Usage: `json '{"foo":42}'` or `echo '{"foo":42}' | json`
function json() { # Syntax-highlight JSON strings or files
  if [ -t 0 ]; then # argument
    python -mjson.tool <<< "$*" | pygmentize -l javascript
  else # pipe
    python -mjson.tool | pygmentize -l javascript
  fi
}
# Usage: `ppgep bash`
function ppgrep() { pgrep "$@" | xargs --no-run-if-empty ps fp; }
