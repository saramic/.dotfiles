# LAPTOP SETUP

1. **Git**
    1. use the default git that comes with mac
    1. create or bring across your ssh key and make sure it's in gitlab
       [Preferences -> User Settings -> SSH
       Keys](https://gitlab.com/-/profile/keys) as per instructions in
       https://docs.gitlab.com/ee/ssh/#rsa-ssh-keys
     ```
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
    ```
    1. review your `~/.gitconfig` file using
    ```
     git config --global --edit

1. **Brew**
    1. use homebrew to manage most dependencies https://brew.sh
    1. following the instructions from above site, in terminal run
something similar to
     ```
       /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
     ```
    1. don't forget to do the final step of the previous command to add it to your profile
     ```
     echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
     eval "$(/opt/homebrew/bin/brew shellenv)"
     ```

1. **iTerm**
    1. setup zsh with ohmyzsh via https://ohmyz.sh/#install (or
    github - https://github.com/ohmyzsh/ohmyzsh)
    ```
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```
