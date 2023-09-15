if [[ -d ${HOME}/.pyenv ]]; then
  # Pyenv enviroment variable.
  # Pyenv settings
  export PYENV_ROOT=${HOME}/.pyenv
  export PATH=${PATH}:${PYENV_ROOT}/bin

  # Load pyenv-virtualenv automatically by adding
  # the following to ~/.zshrc:
  eval "$(pyenv virtualenv-init -)"
fi
