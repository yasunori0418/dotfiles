vim9script

export interface Model
  def ToDict(): dict<any>
endinterface
defcompile Model
