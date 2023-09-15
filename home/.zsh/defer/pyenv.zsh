if [[ -d ${HOME}/.pyenv ]]; then
  # Pyenv enviroment variable.
  # Pyenv settings
  export PYENV_ROOT=${HOME}/.pyenv
  export PATH=${PATH}:${PYENV_ROOT}/bin

  pyenv_cache=${XDG_CACHE_HOME}/pyenv.zsh
  if [[ ! -r ${pyenv_cache} ]]; then
    pyenv init - > ${pyenv_cache}
    pyenv virtualenv-init - >> ${pyenv_cache}
  fi
  source ${pyenv_cache}
fi
