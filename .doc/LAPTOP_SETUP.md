# LAPTOP SETUP

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
  1. setup zsh with ohmyzsh via https://ohmyz.sh/#install (or github -
  https://github.com/ohmyzsh/ohmyzsh)
  ```
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ```
