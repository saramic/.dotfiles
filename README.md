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
