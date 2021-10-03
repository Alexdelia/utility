DEFAULT_USER=adelille

ZSH_THEME="awesomepanda"

# export PATH=/home/user42/pbin:$PATH

# alias norminette="~/.norminette/norminette.rb"
alias norminette_v2="~/.norminette_old/norminette.rb"
alias nor="norminette"
alias gcc="clang-9"
alias clang="clang-9"
alias rmbk=~/.fast_rm_backup.sh

# zsh mod
# autojump
# [[ -s /home/user42/.autojump/etc/profile.d/autojump.sh ]] && source /home/user42/.autojump/etc/profile.d/autojump.sh

autoload -U compinit && compinit -u
# syntax hughlighting
source /home/user42/zsh-mod/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
