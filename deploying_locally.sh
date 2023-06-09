# get repo path
REPO_PATH=`pwd` 
# ------------------------------------------------------------------->>>>>>>>>>
# platform judgement and var setting
# ------------------------------------------------------------------->>>>>>>>>>

echo -e "---------------------------------|\nset conda panels..."

mv $HOME/.condarc $HOME/.condarc_bak && ln -s $REPO_PATH/conda/condarc $HOME/.condarc

platform="`uname`"

if [[ "$platform" == "Linux" ]]; then
    platform="Linux"
    URL=https://micro.mamba.pm/api/micromamba/linux-64/latest
    ROOT_PATH=$HOME/0.apps/micromamba

elif [[ "$platform" == "Darwin" ]]; then
    if [[ "`uname -p`" == "i386" ]]; then
        platform="MacOS/x86_64"
        URL=https://micro.mamba.pm/api/micromamba/osx-64/latest
        ROOT_PATH=$HOME/micromamba
    elif [[ "`uname -p`" == "arm" ]]; then
        platform="MacOS/arm64"
        URL=https://micro.mamba.pm/api/micromamba/osx-arm64/latest
        ROOT_PATH=$HOME/micromamba
    fi

elif [[ "$platform" == "WindowsNT" ]]; then
    platform="Windows"  # TODO, no strategy now
    echo "unsupported OS: $platform!"
    exit 1
else
    echo "unsupported OS: $platform!"
    exit 1
fi
echo -e "---------------------------------|\nplatform detected: $platform"


# ------------------------------------------------------------------->>>>>>>>>>
# micromamba setting (annotate if not use)
# ------------------------------------------------------------------->>>>>>>>>>

echo -e "---------------------------------|\nset conda env config files..."

# install micromamba
if [ ! -f "$ROOT_PATH/bin/micromamba" ];then
    echo "micromamba not found @$ROOT_PATH/bin/! start to install..."
    mkdir -p $ROOT_PATH
    cd $ROOT_PATH
    curl -Ls $URL | tar -xvj bin/micromamba
    cd $REPO_PATH
else
    echo "micromamba exists @$ROOT_PATH/bin/! skip installing..."
fi
# set yml files...
echo "start to choose env.yml..."
# make softlink directory
CONDA_ENVS=$REPO_PATH/conda_local_env_settings
mkdir -p $CONDA_ENVS

for yml in `ls $REPO_PATH/conda/$platform/*.yml`; do
    ln -sf $yml $CONDA_ENVS/`basename $yml`
done
echo "conda config files @: $CONDA_ENVS "

# ------------------------------------------------------------------->>>>>>>>>>
# zsh setting (annotate if not use)
# ------------------------------------------------------------------->>>>>>>>>>

echo -e "---------------------------------|\nset zsh config file"

platform="`echo $platform | awk -F '/' '{printf $1}'`"  # fix "MacOS/x86_64" or "MacOS/arm64" to "MacOS"
mv $HOME/.zshrc $HOME/.zshrc_bak && ln -s $REPO_PATH/zsh/$platform/zshrc $HOME/.zshrc
echo "zsh config file @: $REPO_PATH/zsh/$platform/zshrc"

# ------------------------------------------------------------------->>>>>>>>>>
# vim setting (annotate if not use)
# ------------------------------------------------------------------->>>>>>>>>>
echo -e "---------------------------------|\nset vim config file"
rm -rf $HOME/.vim $HOME/.vimrc
curl https://raw.githubusercontent.com/hermanzhaozzzz/vim-for-coding/master/install.sh | sh
echo "vim config file @ $HOME/.vim"
echo -e "---------------------------------|\nall done"


# end
echo "↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓"
echo -e "well done there! now you should:\n"
echo -e "\t\tsource ~/.zshrc"
echo -e "\t\tconda install -f $CONDA_ENVS/base.yml"
echo "and start to use this environment."
echo "↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑"

echo "ヾ(≧O≦)〃~"
