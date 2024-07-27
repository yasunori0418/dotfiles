vim9script noclear

def InitPlugin(repo: string, host: string = 'github.com'): void
  const repo_path = $'{host}/{repo}'
  const repo_dir = $'{g:dpp_cache}/repos/{repo_path}'
  const repo_url = $'https://{repo_path}'
  if !isdirectory(repo_dir)
    [
      'git',
      'clone',
      '--filter=blob:none',
      repo_url,
      repo_dir
    ]->join(' ')->system()
  endif
  execute $'set runtimepath^={repo_dir}'
enddef

def DppSetup()
  import autoload 'dpp.vim' as dpp
  echomsg dpp.load_state(g:dpp_cache)
  #if dpp.load_state(g:dpp_cache)
    #echomsg 'import dpp.vim'
  #endif
enddef

export def Setup(): void
  InitPlugin("Shougo/dpp-ext-lazy")
  InitPlugin("Shougo/dpp-ext-toml")
  InitPlugin("Shougo/dpp-ext-installer")
  InitPlugin("Shougo/dpp-protocol-git")
  InitPlugin("Shougo/dpp.vim")
  InitPlugin("vim-denops/denops.vim")
  echomsg &rtp
enddef
