# .dotfiles

stored in a `bare` git repository (
  [link](https://www.atlassian.com/git/tutorials/dotfiles)
)

```
alias config='/opt/homebrew/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
echo ".dotfiles" >> .gitignore
git clone --bare <git-repo-url> $HOME/.dotfiles
config checkout

# probably want to
config config --local status.showUntrackedFiles no
```

if there are errors due to existing files

```
mkdir -p .config-backup && \
  config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
  xargs -I{} mv {} .config-backup/{}
```

## OhMyZsh

What needs to be done to re-install ohMyZsh?

## make

```
make
make check-tools     # check required tools
make dev-env         # setup the default developer environment
make update-dev-env  # update brew and setup the default developer environment
```

## Neovim

as per

[
  ![0 to LSP : Neovim RC From Scratch - ThePrimeagen
  ](http://img.youtube.com/vi/w7i4amO_zaE/0.jpg)
](http://youtu.be/w7i4amO_zaE)

**0 to LSP : Neovim RC From Scratch - ThePrimeagen**

and https://github.com/ThePrimeagen/init.lua

```
:h rtp # runtimepath for nvim
%      # create a new file
d      # create a directory
:so    # source current file

# ' ' space set as leader
# SPACE P V to open Ex file explorer
```

from https://github.com/wbthomason/packer.nvim

```
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

add section to load in `packer.lua` and run

```
:PackerSync
```

```
https://github.com/nvim-telescope/telescope.nvim
# paste packer install
# Visual select and '=' to align
# SPACE pf - files
# SPACE ps - search
# CTRL p - in git
```

theme https://github.com/rose-pine/neovim

```
:lua ColorMyPencils() # to re-call the color method
```

also:
- https://github.com/nvim-treesitter/nvim-treesitter
- https://github.com/ThePrimeagen/harpoon
- https://github.com/mbbill/undotree
- https://github.com/tpope/vim-fugitive
- https://github.com/VonHeikemen/lsp-zero.nvim

## Doom Emacs

as per https://github.com/doomemacs/doomemacs and
[
  ![Doom Emacs On Day One (Learn These Things FIRST!) - DistroTube
  ](http://img.youtube.com/vi/37H7bD-G7nE/0.jpg)
](http://youtu.be/37H7bD-G7nE)

**Doom Emacs On Day One (Learn These Things FIRST!) - DistroTube**

```
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install
```

```
# assuming the daemon is running
/opt/homebrew/bin/emacs --daemon
# TODO: start this up with launchd?

# aliased emacsclient as just 'emacs'
emacs
```

