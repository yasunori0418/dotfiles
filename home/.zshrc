if [[ ! $(command -v sheldon) ]]; then
  curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
  | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
fi

eval "$(sheldon source)"
