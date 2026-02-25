# PS1
bgcolor_magenta='\[\e[0;45m\]'
bgcolor_green='\[\e[0;42m\]'
fgcolor_blue='\[\e[0;34m\]'
color_clear='\[\e[0m\]'
PS1="${bgcolor_green}\h@\u${color_clear}${bgcolor_magenta}\w${color_clear}\$ "

# aliases
alias ls='ls -F --color=auto'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
