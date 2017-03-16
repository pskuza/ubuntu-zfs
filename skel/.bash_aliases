[ ! -e ~/.ssh ] && install -d -m 700 ~/.ssh
grep -q "HashKnownHosts" ~/.ssh/config || tee -a ~/.ssh/config <<EOF
HashKnownHosts no
EOF

alias docker-compose=docker-compose-1.10.0.sh
alias g=git
alias zl="sudo zfs list -oname,lused,usedds,usedchild,usedsnap,used,avail,refer,mountpoint,mounted,canmount"
alias zll="sudo zfs list -oname,dedup,compress,compressratio,checksum,sync,quota,copies,atime,devices,exec,rdonly,setuid,xattr,acltype,aclinherit"
alias zls="sudo zfs list -t snap -oname,used,avail,refer"
alias zpl="sudo zpool list -oname,size,alloc,free,cap,dedup,health,frag,ashift,freeing,expandsz,expand,replace,readonly,altroot"
alias zs="sudo zpool status"
alias zio="sudo zpool iostat"

function whatismydhcpserver() {
  for i in $(ps aux | grep -o '[/]var/lib/NetworkManager/\S*.lease') \
    $(ps aux | grep -o '[/]var/lib/dhcp/dhclient\S*.leases'); do
    [ -f ${i} ] && cat ${i} | grep "dhcp-server-identifier"
  done
}
function firstlastline() {
  head -n1 "${1}"
  tail -n1 "${1}"
}
function copypubkey2clipboard() {
  for i in ~/.ssh/id_ed25519.pub \
    ~/.ssh/id_rsa.pub; do
    [ -e ${i} ] && cat ${i} | xsel --clipboard
  done
}
# Usage: json '{"foo":42}' or echo '{"foo":42}' | json
function json() { # Syntax-highlight JSON strings or files
  if [ -t 0 ]; then # argument
    python -mjson.tool <<< "$*" | pygmentize -l javascript
  else # pipe
    python -mjson.tool | pygmentize -l javascript
  fi
}
# Usage: ppgep bash
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
      set --
      ;;
    *)
      set -- docker "${@}"
      ;;
  esac
  "${@}"
}
function v() {
  case "${1}" in
    i)
      set -- vagrant box list
      ;;
    p)
      set -- vagrant status
      ;;
    e)
      shift
      set -- vagrant ssh -c "${@}"
      ;;
    s)
      set -- vagrant ssh
      ;;
    gc)
      set -- vagrant destroy -f
      ;;
    *)
      set -- vagrant "${@}"
      ;;
  esac
  "${@}"
}
