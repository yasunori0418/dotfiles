vim9script

import autoload '../model.vim' as model

export class VimrcSkipRule implements model.Model
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
defcompile VimrcSkipRule.new

export class Directories implements model.Model
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
defcompile Directories.new

export class ExtraArgs implements model.Model
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
    return {
      vimrcSkipRules: this.vimrc_skip_rules->mapnew((rule) => rule.ToDict()),
      directories: this.directories.ToDict(),
      noLazyTomlNames: this.no_lazy_toml_names,
      checkFilesGlobs: this.check_files_globs,
    }
  enddef
endclass
defcompile ExtraArgs
