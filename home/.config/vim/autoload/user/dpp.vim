vim9script

import autoload './dpp/types.vim' as types

const GetBaseDir = (dir: string): string => ['$XDG_CONFIG_HOME/vim'->expand(), dir]->join('/')
const base_dir = ['$XDG_CONFIG_HOME/vim'->expand(), null_string]->join('/')
const rc_dir = GetBaseDir('rc')
const toml_dir = GetBaseDir('toml')
GetBaseDir('hooks')->setenv('HOOKS_DIR')
const dpp_base_path = '$XDG_CACHE_HOME/dpp'->expand()

class Plugin
  var repo: string
  var host: string
  var base_path: string
  var repo_path: string
  var repo_dir: string
  var repo_http_url: string

  def new(
    this.repo,
    this.host,
    this.base_path,
  )
    this
      ._SetRepoPath()
      ._SetRepoDir()
      ._SetRepoHttpUrl()
      ._Init()
      ._SetRuntimepath()
  enddef

  def _SetRepoPath(): Plugin
    this.repo_path = [this.host, this.repo]->join('/')
    return this
  enddef

  def _SetRepoDir(): Plugin
    this.repo_dir = [this.base_path, 'repos', this.repo_path]->join('/')
    return this
  enddef

  def _SetRepoHttpUrl(): Plugin
    this.repo_http_url = ['https://', this.repo_path]->join('/')
    return this
  enddef

  def _Init(): Plugin
    if isdirectory(this.repo_dir)
      return this
    endif
    [
      'git',
      'clone',
      '--filter=blob:none',
      this.repo_http_url,
      this.repo_dir
    ]->join(' ')->system()
    return this
  enddef

  def _SetRuntimepath(): void
    execute($'set runtimepath^={this.repo_dir}')
  enddef
endclass
defcompile Plugin.new

def CheckFilesPattern(glob_patterns: list<string>): string
  return glob_patterns
    ->mapnew((_, glob_pattern) => 
      $'~/dotfiles/home/.config/vim/{glob_pattern},$XDG_CONFIG_HOME/vim/{glob_pattern}'->expand()
    )->join(',')
enddef
defcompile CheckFilesPattern

def AutoInstallPlugins(): void
  const not_install_plugins = dpp#get()
    ->values()
    ->filter((idx, val) => !isdirectory(val.rtp))
  if len(not_install_plugins) > 0
    denops#server#wait_async(() => {
      dpp#async_ext_action('installer', 'install')
    })
    augroup RcAutocmds
      autocmd User Dpp:makeStatePost quit!
    augroup END
  endif
enddef
defcompile AutoInstallPlugins

def MakeState(extraArgs: types.ExtraArgs): void
  dpp#make_state(
    dpp_base_path,
    '$XDG_CONFIG_HOME/dpp/config.ts'->expand(),
    'vim',
    extraArgs.ToDict()
  )
  augroup RcAutocmds
    autocmd User Dpp:makeStatePost ++once ++nested {
      dpp#min#load_state(dpp_base_path)
      AutoInstallPlugins()
    }
  augroup END
enddef
defcompile MakeState

def DppSetup(extraArgs: types.ExtraArgs): void
  if dpp#min#load_state(dpp_base_path)
    denops#server#wait_async(() => MakeState(extraArgs))
  else
    AutoInstallPlugins()
  endif
  const check_files_autocmd = {
    group: 'RcAutocmds',
    event: 'BufWritePost',
    pattern: CheckFilesPattern(extraArgs.check_files_globs),
    cmd: [
      'echowindow "dpp check_files() is run"',
      'call dpp#check_files()'
    ]->join(' | '),
  }
  const make_state_post_autocmd = {
    group: 'RcAutocmds',
    event: 'User',
    pattern: 'Dpp:makeStatePost',
    cmd: 'echowindow "dpp make_state() is done"',
  }
  [check_files_autocmd, make_state_post_autocmd]->autocmd_add()
enddef
defcompile DppSetup

export def Setup(): void
  const vimrcSkipRules: list<types.VimrcSkipRule> = []
  const directories: types.Directories = types.Directories.new(base_dir, rc_dir, toml_dir)
  const noLazyTomlNames: list<string> = ['dpp.toml', 'no_lazy.toml']
  const checkFilesGlobs: list<string> = [
    '**/*.toml',
    '**/*.vim',
    '**/*.ts',
    'vimrc',
  ]
  const extraArgs: types.ExtraArgs = types.ExtraArgs.new(
    vimrcSkipRules,
    directories,
    noLazyTomlNames,
    checkFilesGlobs,
  )

  [
    'Shougo/dpp-ext-lazy',
    'Shougo/dpp-ext-toml',
    'Shougo/dpp-ext-installer',
    'Shougo/dpp-protocol-git',
    'Shougo/dpp.vim',
    'vim-denops/denops.vim',
  ]->foreach((_, name: string) => Plugin.new(name, 'github.com', dpp_base_path))

  DppSetup(extraArgs)
enddef
defcompile Setup
