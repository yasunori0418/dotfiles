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

git_rebase_onto ()
{
  local rebase_point="$1"
  local stump_tag="$2.stump"
  local target_branch= "$2"
  readonly rebase_point stump_tag target_branch
  # https://qiita.com/sotarok/items/07c6b2cca5ed2f9a53a6
  # git rebase --onto どこへ($rebase_point) どこから($stump_tag) どのブランチを($target_branch)
  git rebase --onto ${rebase_point} ${stump_tag} ${target_branch}
  git tag -d ${stump_tag}
  git tag -am "created_at: $(date +%Y/%m/%d\ %H:%M:%S)" ${stump_tag} $(git hash ${rebase_point})
}
