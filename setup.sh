#! /usr/bin/env bash

#########
### Setup the environment
#########

####
## functions
####

path=$(cd $(dirname $0) && pwd)

linker(){
  if [ -L $1 ]; then
    echo "$1 has already exist"
    return 1
  elif [ -e $1 ]; then
    rm $1 -rf
  fi
  return 0
}

slink() {
  if [ ! -e $path/$1 ];then
    echo "$path/$1 not exists"
    return 1
  fi
  if linker $2/$(basename $1);then
    ln -s $path/$1 $2/$(basename $1)
    echo "$(basename $1) was linked to $2/"
    return 0
  else
    return 1
  fi
}

deploy_git() {
  slink .gitconfig $HOME
  if [ -L $HOME/Utils ];then
    echo "$HOME/Utils directory has already exist"
    if [[ "$(uname)" = 'Darwin' ]]; then
        which brew > /dev/null 2>&1 || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        which git > /dev/null 2>&1 || brew install git
    elif [[ "$(uname)" = 'Linux' ]]; then
        cd $HOME/Utils
        wget https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
        wget https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh
    elif [[ "$(uname -r)" =~ ^.*-Microsoft$ ]]; then
        cd $HOME/Utils
        wget https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
        wget https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh
    fi
    return 0
  else
    if [[ "$(uname)" = 'Darwin' ]]; then
        which brew > /dev/null 2>&1 || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        which git > /dev/null 2>&1 || brew install git
    elif [[ "$(uname)" = 'Linux' ]]; then
        mkdir $HOME/Utils
        cd $HOME/Utils
        wget https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
        wget https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh
    elif [[ "$(uname -r)" =~ ^.*-Microsoft$ ]]; then
        mkdir $HOME/Utils
        cd $HOME/Utils
        wget https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
        wget https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh
    fi
    return 0
  fi
}


#################

####
# General settings
####
slink tmux/.tmux.conf $HOME
slink .vimrc $HOME
deploy_git

####
## OS dependented bashrc
####
if [[ "$(uname)" = 'Darwin' ]]
then
  slink bashrcs/mac/.bash_profile $HOME
  slink bashrcs/mac/.bashrc $HOME

elif [[ "$(uname)" = 'Linux' ]]
then
  slink bashrcs/linux/.bashrc $HOME

elif [[ "$(uname -r)" =~ ^.*-Microsoft$ ]]
then
  slink bashrcs/wsl/.bashrc $HOME
fi