# Custom cd command
function custom_cd() {
  \cd $@ ; cc la
}

function git_root() {
  cd `git root`
}
