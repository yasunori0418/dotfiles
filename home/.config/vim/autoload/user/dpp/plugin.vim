vim9script

export class Plugin
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

