# LAPTOP SETUP

1. start the machine
    1. choose all sain settings for your locale
    1. log into **iCould account** even for work laptop
       > this will allow you to save documents and notes to the
       > cloud which may be helpful for transferring to another
       > machine, a backup, accessing from a phone or the web,
       > finding your device, etc.

1. **System Update**
    1. once fully booted
    1. run a system update `System Preferences -> Software Updates`
       > every new machine is likely to be behind on software
       > updates

1. install command line tools
   ```
   xcode-select --install
   ```

1. **using existing .dotfiles**
   ```
   git clone --bare git@github.com:saramic/.dotfiles.git $HOME/.dotfiles
   # based on which git
   alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
   config status
   config config --local status.showUntrackedFiles no
   ```

1. **Git**
    1. review your `~/.gitconfig` file using, below, it should be already setup
       ```
       git config --global --edit
       ```
    1. or use the following to set it up
      1. use the default git that comes with mac
      1. create or bring across your ssh key and make sure it's in gitlab
         [Preferences -> User Settings -> SSH
         Keys](https://gitlab.com/-/profile/keys) as per instructions in
         https://docs.gitlab.com/ee/ssh/#rsa-ssh-keys
         ```
         # NEW
         # based on
         #  https://www.keystash.io/guides/how-to-generate-the-best-ssh-keys.html
         ssh-keygen -o -a 100 -t ed25519
         # OLD
         ssh-keygen -t rsa -b 2048 -C "my UNIQUE NAME key"
         ```
      1. setup sane git defaults
         ```
         git config --global pull.rebase true
         git config --global user.name "Michael Milewski"
         git config --global user.email saramic@gmail.com
         git config --global core.editor vi
         # git config --global core.editor "code --wait"
         git config --global --replace-all core.pager "less -F -X"
         git config --global init.defaultBranch main
         git config --global core.excludesfile ~/.gitignore_global
         ```
      1. review your `~/.gitconfig` file using
         ```
         git config --global --edit
         ```

1. **Mandatory Setup**
   these are referenced by the dot files above
   1. **Brew** _(also see below)_
      ```
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      ```
   1. **OhMyZSH** _(also see below)_
      ```
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

      # confirm changes and ignore the new .zshrc file
      vimdiff .zshrc .zshrc.pre-oh-my-zsh
      mv .zshrc.pre-oh-my-zsh .zshrc
      ```
   1. **First time make**
      ```
      make update-dev-env
      # will now have brew git so can update
      alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
      ```
   1. **ASDF install**
      ```
      asdf install
      ```
   1. **NVIM**
      install packer
      ```
      git clone --depth 1 https://github.com/wbthomason/packer.nvim\
        ~/.local/share/nvim/site/pack/packer/start/packer.nvim
      ```
      inside a nvim session
      ```
      :PackerSync
      ```
      finally make it your vim
      ```
      ln -s /opt/homebrew/bin/nvim /opt/homebrew/bin/vi
      ```
   1. **emacs**
      ```
      git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
      ~/.config/emacs/bin/doom install
      /opt/homebrew/bin/emacs --daemon
      emacs
      ```
      also in iTerm2 Preferences -> Profiles -> Keys -> General

      set the Left Option Key: -> Esc+

1. **Configure essentials**
    1. **Terminal** worth setting up even if you plan to use iTerm most of the time
        1. General -> new window open with: **default working directory**
        1. General -> new tab open with: **same working directory**
        1. Profiles -> theme: **Pro theme** set as default
        1. Profiles -> Text -> color: **no opacity**
        1. Profiles -> Text -> color: **#212121** or RGB 333333 is easier on
           the eyes than black - use the dropper on the default black of VS
           code or similar
        1. Profiles -> Text -> font: **18pt**
        1. Profiles -> Shell -> when the shell exits: **close if the shell exited cleanly**
    1. **iTerm**
        1. setup zsh with ohmyzsh via https://ohmyz.sh/#install (or
        github - https://github.com/ohmyzsh/ohmyzsh)
        ```
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        ```
        1. iTerm2 -> **make iterm2 default terminal**
        1. iTerm2 -> **install shell integation**
        1. Profiles -> General -> Working Directory: **Reuse previous sessions
           directory**
        1. background color: **#212121**
        1. font: **18**
        1. Profiles -> Terminal -> Scrollback Buffer : **unlimited scrollback**
        1. General -> tmux -> When attaching, resotre windows as: **Native tabs
           in a new window**
        1. Add script to support iterm command click
           bin/iterm_command_click
    1. **Zoom** and **Chrome** and **Tuple**
        1. will need accessibility settings configured for screen sharing etc
    1. **Slack**
        1. login to all the things
    1. **VS Code**
        1. install worthwhile plugins (or use a shared `.vscode` file)
        > 1. ensure press and hold key repeat works
        > ```
        > defaults write -g ApplePressAndHoldEnabled -bool false
        > defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
        > ```

1. **Brew**
    1. use homebrew to manage most dependencies https://brew.sh
    1. following the instructions from above site, in terminal run something
       similar to
       ```
       /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
       ```
    1. don't forget to do the final step of the previous command to add it to your profile
     ```
     echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
     eval "$(/opt/homebrew/bin/brew shellenv)"
     ```
    1.

1. **install ASDF** runtime version manager (JS, Ruby, Python, Postgres, etc)
    1. should have been done using `make update-dev-env`
    1. if `asdf` command does not work maybe you forgot to add `asdf` to `.zshrc`
    ```
    echo '. $HOME/.asdf/asdf.sh' >> ~/.zshrc
    ```
    1. **M1** architecture note nodejs needs the **x86_64** flag
    ```
    arch -x86_64 asdf install nodejs 14.17.6
    ```
    1. note postgres will need to be stopped and started using something like
       the following (TODO move to script)
    ```
    pg_ctl \
      -D /Users/$USER/.asdf/installs/postgres/12.11/data \
      -l tmp/logfile start
    ```
    1. also a good idea to create a database with the name of the system
       `$USER` cause that is what `psql` wants to open by default
    ```
    createdb $USER
    psql
    ```
    1. on M1 may need to install with
    ```
    MAKELEVEL=0 asdf install postgres 12.11
    ```
    1. may need to install `libpq` and to install postgres gem in ruby
    ```
    gem install pg -v1.5.3 \
      -- --with-pg-config="/opt/homebrew/opt/libpq/bin/pg_config"
    ```

1. **Mac OSX** some sane non standard settings
    1. right click the dock **Turn Hiding On**
    1. Finder
        1. show hidden files `Cmd Shift .`
        1. add useful diredctory shortcuts
            1. in terminal, open 1 below your home directory `open ~/..`
            1. drag your home directory to LHS Favourites
            1. navigate to Projects and drag that to LHS Favourites
    1. System Prefrences -> Keyboard -> Key repeat **fast**
    1. System Prefrences -> Keyboard -> Delay until repeat **short**
    1. System Prefrences -> Trackpad -> **tap to click**
    1. System Prefrences -> Mouse -> **Secondary click**
    1. System Prefrences -> Control Centre -> Bluewtooth -> **Show in Menu Bar**
    1. Power moves (vi users)
        1. System Prefrences -> Keyboard -> Keyboard Shortcuts...
           -> Modifier Keys -> Caps Lock Key -> Escape

1. **Vi**
    > 1. let's face it at some stage you are going to open vi (VIsual editor) so
    >    you may as well set it up
    > 1. install a plugin management system like
    >    https://github.com/junegunn/vim-plug
    > ```
    > curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    >     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    > ```
    > 1. get a copy of a minimal `~/.vimrc` file
    >    ```
    >    cp config/.vimrc ~/
    >    mkdir ~/.vim/swaps
    >    mkdir ~/.vim/backups
    >    ```
    >    and in vim
    > ```
    > :PlugInstall
    > ```
    1. for vi on the command line
    ```
    echo "set -o vi"            >> ~/.zshrc
    echo "set editing-mode vi"  >> ~/.inputrc
    echo "bind -v"              >> ~/.editrc
    ```

1. **Other**
    1. set a default EDITOR
    ```
    echo 'export EDITOR=vi'     >> ~/.zshrc
    ```
    > 1. set a default BETTER_ERRORS_EDITOR if different to above for click and
    >    edit from rails dev error in browser
    > ```
    > echo 'export BETTER_ERRORS_EDITOR="code --wait"' >> ~/.zshrc
    > ```

1. **VIM in VSCode**
    > assuming you have installed the (VSCodeVim
    > plugin](https://github.com/VSCodeVim/Vim) you may still need to enable key
    > repeating as per https://github.com/VSCodeVim/Vim#mac
    > ```
    > defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false         # For VS Code
    > defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false # For VS Code Insider
    > defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false    # For VS Codium
    > defaults delete -g ApplePressAndHoldEnabled                                      # If necessary, reset global default
    > ```
    > followed by a restart of VSCode

- **Neovim**
    - make it your vi
    ```
    ln -s /opt/homebrew/bin/nvim /opt/homebrew/bin/vi
    ```
    - do a packer sync
    ```
    :PackerSync
    ```
    > - install a plugin manager
    > ```
    > via https://github.com/junegunn/vim-plug
    > sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    > https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    > ```
    > - get a sane nvim config in `~/.config/nvim/init.vim`
    >   ```
    >   mkdir -p ~/.config/nvim
    >   cp config/.config/nvim/init.vim ~/.config/nvim/
    >   ```
    >   and in nvim run
    > ```
    > :PlugInstall
    > ```

- **Ruby**
    TODO: default `.rspec` with `--format documentation`
    TODO: env var to use readline in irb by default

- **Git**
    TODO: up above add `.gitmessage` for a default git message
