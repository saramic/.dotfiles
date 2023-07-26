# .dotfiles

stored in a `bare` git repository (
  [link](https://www.atlassian.com/git/tutorials/dotfiles)
)

```
alias config='/opt/homebrew/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
echo ".dotfiles" >> .gitignore
git clone --bare <git-repo-url> $HOME/.dotfiles
config checkout
```

if there are errors due to existing files

```
mkdir -p .config-backup && \
  config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
  xargs -I{} mv {} .config-backup/{}
```

# OhMyZsh

What needs to be done to re-install ohMyZsh?

# make

```
make
make check-tools     # check required tools
make dev-env         # setup the default developer environment
make update-dev-env  # update brew and setup the default developer environment
```

# Doom Emacs

as per https://github.com/doomemacs/doomemacs and
[
  ![Doom Emacs On Day One (Learn These Things FIRST!) - DistroTube
  ](http://img.youtube.com/vi/37H7bD-G7nE/0.jpg)
](http://youtu.be/37H7bD-G7nE)

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

