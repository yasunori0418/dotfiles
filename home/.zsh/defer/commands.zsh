# Custom cd command
custom_cd ()
{
  \cd $@ ; cc la
}

git_root ()
{
  cd $(git root)
}

git_branch_point ()
{
  local branch_name="${@}"
  local tag_name="${branch_name}.stump"
  readonly tag_name branch_name
  git tag -am "created_at: $(date +%Y/%m/%d\ %H:%M:%S)" ${tag_name}
  git switch -c ${branch_name}
}
}
