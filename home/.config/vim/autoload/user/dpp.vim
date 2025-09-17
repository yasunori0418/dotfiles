vim9script

const GetBaseDir = (dir: string): string => ['$XDG_CONFIG_HOME/vim'->expand(), dir]->join('/')
const base_dir = ['$XDG_CONFIG_HOME/vim'->expand(), null_string]->join('/')
const rc_dir = GetBaseDir('rc')
const toml_dir = GetBaseDir('toml')
GetBaseDir('hooks')->setenv('HOOKS_DIR')
const dpp_base_path = '$XDG_CACHE_HOME/dpp'->expand()

class VimrcSkipRule
  var name: string
  var condition: bool

  def new(this.name, this.condition)
  enddef

  def ToDict(): dict<any>
    return {
      name: this.name,
      condition: this.condition,
    }
  enddef
endclass

class Directories
  var base: string;
  var rc: string;
  var toml: string;

  def new(this.base, this.rc, this.toml)
  enddef

  def ToDict(): dict<any>
    return {
      base: this.base,
      rc: this.rc,
      toml: this.toml,
    }
  enddef
endclass

class ExtraArgs
  var vimrc_skip_rules: list<VimrcSkipRule>
  var directories: Directories
  var no_lazy_toml_names: list<string>
  var check_files_globs: list<string>

  def new(
    this.vimrc_skip_rules,
    this.directories,
    this.no_lazy_toml_names,
    this.check_files_globs,
  )
  enddef

  def ToDict(): dict<any>
    var vimrc_skip_rules = []
    for rule in this.vimrc_skip_rules
      vimrc_skip_rules->add(rule.ToDict())
    endfor
    return {
      vimrcSkipRules: vimrc_skip_rules,
      directories: this.directories.ToDict(),
      noLazyTomlNames: this.no_lazy_toml_names,
      checkFilesGlobs: this.check_files_globs,
    }
  enddef
endclass

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

def CheckFiles(): list<string>
  const glob_patterns = [
    '**/*.toml',
    '**/*.vim',
    '**/*.ts',
    'vimrc',
  ]
  const target_directories = [base_dir, expand('~/dotfiles/config/vim')]->join(',')
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
      dpp#async_ext_action('installer', 'install')
    })
    augroup RcAutocmds
      autocmd User Dpp:makeStatePost quit!
    augroup END
  endif
enddef

def MakeState(extraArgs: ExtraArgs): void
  echomsg $'{base_dir}/dpp/config.ts'
  dpp#make_state(dpp_base_path, '$XDG_CONFIG_HOME/dpp/config.ts'->expand(), 'vim', extraArgs.ToDict())
  augroup RcAutocmds
    autocmd User Dpp:makeStatePost ++once ++nested {
      dpp#min#load_state(dpp_base_path)
      AutoInstallPlugins()
    }
  augroup END
enddef

def DppSetup(extraArgs: ExtraArgs): void
  if dpp#min#load_state(dpp_base_path)
    denops#server#wait_async(() => MakeState(extraArgs))
  else
    AutoInstallPlugins()
  endif
  const check_files_autocmd = {
    group: 'RcAutocmds',
    event: 'BufWritePost',
    pattern: CheckFiles()->join(','),
    cmd: 'echowindow "dpp check_files() is run" | dpp#check_files()',
  }
  const make_state_post_autocmd = {
    group: 'RcAutocmds',
    event: 'User',
    pattern: 'Dpp:makeStatePost',
    cmd: 'echowindow "dpp make_state() is done"',
  }
  [check_files_autocmd, make_state_post_autocmd]->autocmd_add()
enddef

export def Setup(): void
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

  # 本当はmapとかforeachでやりたい
  for name in [
    'Shougo/dpp-ext-lazy',
    'Shougo/dpp-ext-toml',
    'Shougo/dpp-ext-installer',
    'Shougo/dpp-protocol-git',
    'Shougo/dpp.vim',
    'vim-denops/denops.vim',
  ]
    Plugin.new(name, 'github.com', dpp_base_path)
  endfor

  DppSetup(extraArgs)
enddef

