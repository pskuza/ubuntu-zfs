alias docker-compose=docker-compose-1.10.0.sh
alias g=git
alias zl="sudo zfs list -oname,lused,usedds,usedchild,usedsnap,used,avail,refer,mountpoint,mounted,canmount"
alias zll="sudo zfs list -oname,dedup,compress,compressratio,checksum,sync,quota,copies,atime,devices,exec,rdonly,setuid,xattr,acltype,aclinherit"
alias zls="sudo zfs list -t snap -oname,used,avail,refer"
alias zpl="sudo zpool list -oname,size,alloc,free,cap,dedup,health,frag,ashift,freeing,expandsz,expand,replace,readonly,altroot"
alias zs="sudo zpool status"
alias zio="sudo zpool iostat"
function whatismydhcpserver() {
  if ps aux | grep -q -o '[/]var/lib/NetworkManager/\S*.lease'; then
    for i in $(ps aux | grep -o '[/]var/lib/NetworkManager/\S*.lease'); do
      [ -f ${i} ] && cat ${i} | grep "dhcp-server-identifier"
    done
  elif ps aux | grep -q -o '[/]var/lib/dhcp/dhclient\S*.leases'; then
    for i in $(ps aux | grep -o '[/]var/lib/dhcp/dhclient\S*.leases'); do
      [ -f ${i} ] && cat ${i} | grep "dhcp-server-identifier"
    done
  fi
}
function firstlastline() {
  head -n1 "${1}"
  tail -n1 "${1}"
}
function copypubkey2clipboard() {
  which xsel >/dev/null 2>/dev/null || echo "You need xsel: sudo apt install xsel"
  [ -e ~/.ssh/id_ed25519.pub ] && cat ~/.ssh/id_ed25519.pub | xsel --clipboard
  [ -e ~/.ssh/id_rsa.pub ] && cat ~/.ssh/id_rsa.pub | xsel --clipboard
}
# Usage: `json '{"foo":42}'` or `echo '{"foo":42}' | json`
function json() { # Syntax-highlight JSON strings or files
  which pygmentize >/dev/null 2>/dev/null || echo "You need pygmentize: sudo apt install python-pygments"
  if [ -t 0 ]; then # argument
    python -mjson.tool <<< "$*" | pygmentize -l javascript
  else # pipe
    python -mjson.tool | pygmentize -l javascript
  fi
}
# Usage: `ppgep bash`
function ppgrep() { pgrep "$@" | xargs --no-run-if-empty ps fp; }
function d() {
  case "${1}" in
    i)
      set -- docker images
      ;;
    p)
      set -- docker ps -a
      ;;
    e)
      shift
      set -- docker exec -it "${@}"
      ;;
    gc)
      # remove exited containers
      for i in $(docker ps -q -f status=exited); do
        docker rm ${i}
      done
      # remove untagged docker images
      for i in $(docker images -q -f dangling=true); do
        docker rmi ${i}
      done
      exit
      ;;
    *)
      set -- docker "${@}"
      ;;
  esac
  "${@}"
}
