vim9script

class VimrcSkipRule
  var name: string
  var condition: bool

  def new(this.name, this.condition)
  enddef
endclass

class Directories
  var base: string;
  var rc: string;
  var toml: string;

  def new(this.base, this.rc, this.toml)
  enddef
endclass

class ExtraArgs
  var vimrcSkipRules: list<VimrcSkipRule>
  var directories: Directories
  var noLazyTomlNames: list<string>
  var checkFilesGlobs: list<string>

  def new(
    this.vimrcSkipRules,
    this.directories,
    this.noLazyTomlNames,
    this.checkFilesGlobs,
  )
  enddef
endclass

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

def CheckFiles(): list<string>
  const glob_patterns = [
    '**/*.toml',
    '**/*.vim',
    '**/*.ts',
    'vimrc',
  ]
  const target_directories = [g:base_dir, expand('~/dotfiles/config/vim')]->join(',')
  var check_files = []
  for pattern in glob_patterns
    add(
      check_files,
      globpath(target_directories, pattern, v:true, v:true)
    )
  endfor
  return flattennew(check_files)
enddef

def AutoInstallPlugins(): void
  const not_install_plugins = dpp#get()
    ->values()
    ->filter((idx, val) => !isdirectory(val.rtp))
  if len(not_install_plugins) > 0
    denops#server#wait_async(() => {
      dpp#async_ext_action("installer", "install")
    })
    augroup RcAutocmds
      autocmd User Dpp:makeStatePost quit!
    augroup END
  endif
enddef

def MakeState(): void
  dpp#make_state(g:dpp_cache, $'{g:base_dir}/dpp/config.ts')
  augroup RcAutocmds
    autocmd User Dpp:makeStatePost ++once ++nested {
      dpp#min#load_state(g:dpp_cache)
      AutoInstallPlugins()
    }
  augroup END
enddef

def DppSetup(): void
  if dpp#min#load_state(g:dpp_cache)
    denops#server#wait_async(() => {
      MakeState()
    })
  else
    AutoInstallPlugins()
  endif
  const check_files_autocmd = {
    'group': 'RcAutocmds',
    'event': 'BufWritePost',
    'pattern': CheckFiles()->join(','),
    'cmd': 'echowindow "dpp check_files() is run" | dpp#check_files()',
  }
  const make_state_post_autocmd = {
    'group': 'RcAutocmds',
    'event': 'User',
    'pattern': 'Dpp:makeStatePost',
    'cmd': 'echowindow "dpp make_state() is done" | quitall!',
  }
  [check_files_autocmd, make_state_post_autocmd]->autocmd_add()
enddef

export def Setup(): void
  const GetBaseDir = (dir: string): string =>
    ['$XDG_CONFIG_HOME/vim'->expand(), dir]->join('/')
  const base_dir = GetBaseDir(null_string)
  const rc_dir = GetBaseDir('rc')
  const toml_dir = GetBaseDir('toml')
  GetBaseDir('hooks')->setenv('HOOKS_DIR')

  const vimrcSkipRules: list<VimrcSkipRule> = []
  const directories: Directories = Directories.new(base_dir, toml_dir, rc_dir)
  const noLazyTomlNames: list<string> = ['dpp.toml', 'no_lazy.toml']
  const checkFilesGlobs: list<string> = [
    '**/*.toml',
    '**/*.vim',
    '**/*.ts',
    'vimrc',
  ]
  const extraArgs: ExtraArgs = ExtraArgs.new(
    vimrcSkipRules,
    directories,
    noLazyTomlNames,
    checkFilesGlobs,
  )

  InitPlugin("Shougo/dpp-ext-lazy")
  InitPlugin("Shougo/dpp-ext-toml")
  InitPlugin("Shougo/dpp-ext-installer")
  InitPlugin("Shougo/dpp-protocol-git")
  InitPlugin("Shougo/dpp.vim")
  InitPlugin("vim-denops/denops.vim")
  DppSetup()
enddef
