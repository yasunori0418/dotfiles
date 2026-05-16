complete -C $(which aws_completer) aws

source <(fzf --zsh)

# https://atsum.in/aws/ctrl-y/
# awsのsession managerでctrl-yでセッションが切断されないようにする
stty dsusp undef
