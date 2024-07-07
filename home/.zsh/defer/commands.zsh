# Custom cd command
custom_cd ()
{
  \cd $@ ; cc la
}

git_root ()
{
  cd $(git root)
}
