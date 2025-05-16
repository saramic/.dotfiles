# just file for managing this repo with just
# more info:
#   - https://github.com/casey/just
#   - https://just.systems/man/en/

# need bash on GHActions, override locally if you have issues with output using
#       alias just="just --shell \"zsh\""
set shell := ["zsh", "-uc"]

# user and repo
user        := `whoami`
current_dir := `basename $( pwd )`

# Colors
RED     := "\\u001b[31m"
GREEN   := "\\u001b[32m"
YELLOW  := "\\u001b[33m"
BLUE    := "\\u001b[34m"
MAGENTA := "\\u001b[35m"
BOLD    := "\\u001b[1m"
RESET   := "\\u001b[0m"

_default:
    @echo "\nHi {{GREEN}}{{user}}!{{RESET}} Welcome to {{RED}}{{current_dir}}{{RESET}}\n"

    @just --list --unsorted

# demo
@demo:
    echo "{{RED}}❌ hi in red{{RESET}}"
    just _announce_rb "✅ hi in green" "{{GREEN}}"
    just _announce_js "🟡 hi in yellow" "{{YELLOW}}"
    just _announce "🔵 hi in blue" "{{BLUE}}"
    just _announce "🟣 hi in magenta" "{{MAGENTA}}"

# bootstrap the .dotfiles can run with: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/saramic/.dotfiles/refs/heads/main/.bin/bootstrap.sh)"
bootstrap:
    .bin/bootstrap.sh

# check required tools
check-tools:
    .bin/makefile/check-tools

# setup the default developer environment
dev-env:
    .bin/makefile/dev-env

# update brew and setup the default developer environment
update-dev-env:
    .bin/makefile/dev-env --update

## Hidden recipies

_bold_squares message:
    @echo -e "{{BOLD}}[{{RESET}}{{message}}{{RESET}}{{BOLD}}]{{RESET}}"

_announce message color:
    #!/usr/bin/env zsh
    echo -e "{{color}}{{message}}{{RESET}}"

_announce_rb message color:
    #!/usr/bin/env ruby
    puts "{{color}}{{message}}{{RESET}}"

_announce_js message color:
    #!/usr/bin/env node
    console.log('{{color}}{{message}}{{RESET}}')
