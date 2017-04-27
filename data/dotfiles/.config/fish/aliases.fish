# Quick edits
alias ea 'vim ~/.config/fish/aliases.fish'
alias ef 'vim ~/.config/fish/config.fish'
alias eg 'vim ~/.gitconfig'
alias ev 'vim ~/.vimrc'
alias et 'vim ~/.tmux.conf'
alias ect 'vim ~/.clitools.ini'
alias vim-norc 'vim -u NORC'
alias vim-none 'vim -u NONE'

alias cd.. 'cd ..'
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'

alias fch 'sudo fc-cache -fv'

alias md 'mkdir -p'
function take
    set -l dir $argv[1]
    mkdir -p $dir; and cd $dir
end
alias cx 'chmod +x'
alias 'c-x' 'chmod -x'


function timestamp
    python -c 'import time; print(int(time.time()))'
end

function vhomestead
    cd ~/.config/composer/vendor/laravel/homestead; vagrant $argv
end

function art
    php artisan $argv
end

function app
    docker-compose run app $argv
end

function app:pa
    docker-compose run app php artisan $argv
end

function wtf -d "Print which and --version output for the given command"
    for arg in $argv
        echo $arg: (which $arg)
        echo $arg: (sh -c "$arg --version")
    end
end
