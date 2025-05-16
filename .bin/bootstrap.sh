#!/bin/bash

# We don't need return codes for "$(command)", only stdout is needed.
# Allow `[[ -n "$(command)" ]]`, `func "$(command)"`, pipes, etc.
# shellcheck disable=SC2312

set -u

abort() {
  printf "%s\n" "$@" >&2
  exit 1
}

# Fail fast with a concise message when not using bash
# Single brackets are needed here for POSIX compatibility
# shellcheck disable=SC2292
if [ -z "${BASH_VERSION:-}" ]
then
  abort "Bash is required to interpret this script."
fi

# string formatters
if [[ -t 1 ]]
then
  tty_escape() { printf "\033[%sm" "$1"; }
else
  tty_escape() { :; }
fi
tty_mkbold() { tty_escape "1;$1"; }
tty_underline="$(tty_escape "4;39")"
tty_blue="$(tty_mkbold 34)"
tty_green="$(tty_mkbold 32)"
tty_red="$(tty_mkbold 31)"
tty_bold="$(tty_mkbold 39)"
tty_reset="$(tty_escape 0)"

shell_join() {
  local arg
  printf "%s" "$1"
  shift
  for arg in "$@"
  do
    printf " "
    printf "%s" "${arg// /\ }"
  done
}

chomp() {
  printf "%s" "${1/"$'\n'"/}"
}

ohai() {
  printf "${tty_blue}==>${tty_bold} %s${tty_reset}\n" "$(shell_join "$@")"
}

warn() {
  printf "${tty_red}Warning${tty_reset}: %s\n" "$(chomp "$1")" >&2
}

unset HAVE_SUDO_ACCESS # unset this from the environment

have_sudo_access() {
  if [[ ! -x "/usr/bin/sudo" ]]
  then
    return 1
  fi

  local -a SUDO=("/usr/bin/sudo")
  if [[ -n "${SUDO_ASKPASS-}" ]]
  then
    SUDO+=("-A")
  fi

  if [[ -z "${HAVE_SUDO_ACCESS-}" ]]
  then
    "${SUDO[@]}" -v && "${SUDO[@]}" -l mkdir &>/dev/null
    HAVE_SUDO_ACCESS="$?"
  fi

  if [[ -n "${BOOTSTRAP_ON_MACOS-}" ]] && [[ "${HAVE_SUDO_ACCESS}" -ne 0 ]]
  then
    abort "Need sudo access on macOS (e.g. the user ${USER} needs to be an Administrator)!"
  fi

  return "${HAVE_SUDO_ACCESS}"
}

execute_sudo() {
  local -a args=("$@")
  if [[ "${EUID:-${UID}}" != "0" ]] && have_sudo_access
  then
    if [[ -n "${SUDO_ASKPASS-}" ]]
    then
      args=("-A" "${args[@]}")
    fi
    ohai "/usr/bin/sudo" "${args[@]}"
    execute "/usr/bin/sudo" "${args[@]}"
  else
    ohai "${args[@]}"
    execute "${args[@]}"
  fi
}

usage() {
  cat <<EOS
Saramic .Dotfile bootstrap
Usage: bootstrap.sh [options]
    -h, --help       Display this message.
EOS
  exit "${1:-0}"
}

while [[ $# -gt 0 ]]
do
  case "$1" in
    -h | --help) usage ;;
    *)
      warn "Unrecognized option: '$1'"
      usage 1
      ;;
  esac
done

# USER isn't always set so provide a fall back for the installer and subprocesses.
if [[ -z "${USER-}" ]]
then
  USER="$(chomp "$(id -un)")"
  export USER
fi

# First check OS.
OS="$(uname)"
if [[ "${OS}" == "Linux" ]]
then
  BOOTSTRAP_ON_LINUX=1
elif [[ "${OS}" == "Darwin" ]]
then
  BOOTSTRAP_ON_MACOS=1
else
  abort "Bootstrap is only supported on  macOS and Linux."
fi

execute() {
  if ! "$@"
  then
    abort "$(printf "Failed during: %s" "$(shell_join "$@")")"
  fi
}

check_run_command_as_root() {
  [[ "${EUID:-${UID}}" == "0" ]] || return

  abort "Don't run this as root!"
}

should_install_command_line_tools() {
  if [[ -n "${BOOTSTRAP_ON_LINUX-}" ]]
  then
    return 1
  fi

  ! [[ -e "/Library/Developer/CommandLineTools/usr/bin/git" ]]
}

####################################################################### script

cat <<EOS
${tty_green}
                         █
                         █
               █████████████████████
 🅳 eveloper       ▜██████▛  ▟▙
 🅸 nfrastructure   ▜████▛  ▟██▙
 🅰 s                ▜██▛  ▟████▙
 🅲 ode               ▜▛  ▟██████▙
                ████████████████████
                         █
                         █${tty_reset}

${tty_bold}Starting install as per 🚀${tty_reset}
  - https://github.com/saramic/.dotfiles

EOS

if [[ -n "${BOOTSTRAP_ON_MACOS-}" ]]
then
  ohai "Detected MacOs - continuing ✅"
else
  abort "Linux not supported yet - aborting ❌"
fi

# shellcheck disable=SC2016
ohai 'Checking for `sudo` access (which may request your password)...'

if [[ -n "${BOOTSTRAP_ON_MACOS-}" ]]
then
  [[ "${EUID:-${UID}}" == "0" ]] || have_sudo_access
elif ! [[ -w "/home" ]] &&
     ! have_sudo_access
then
  abort "$(
    cat <<EOABORT
Insufficient permissions to run Saramic .dotfiles bootstrap.sh script
EOABORT
  )"
fi

check_run_command_as_root

if should_install_command_line_tools
then
  ohai "The Xcode Command Line Tools will be installed."
fi
#
# Headless install may have failed, so fallback to original 'xcode-select' method
if should_install_command_line_tools && test -t 0
then
  ohai "Installing the Command Line Tools (expect a GUI popup):"
  execute "/usr/bin/xcode-select" "--install"
  echo "Press any key when the installation has completed."
  getc
  execute_sudo "/usr/bin/xcode-select" "--switch" "/Library/Developer/CommandLineTools"
fi

if [[ -n "${HOMEBREW_ON_MACOS-}" ]] && ! output="$(/usr/bin/xcrun clang 2>&1)" && [[ "${output}" == *"license"* ]]
then
  abort "$(
    cat <<EOABORT
You have not agreed to the Xcode license.
Before running the installer again please agree to the license by opening
Xcode.app or running:
    sudo xcodebuild -license
EOABORT
  )"
fi

USABLE_GIT=/usr/bin/git

# Setup bear repo
DEFAULT_GIT_REMOTE="https://github.com/saramic/.dotfiles"
# alias config='/opt/homebrew/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# echo ".dotfiles" >> .gitignore
# git clone --bare <git-repo-url> $HOME/.dotfiles
# NOTE: this will not work if ~/.dotfiles already exists
execute "${USABLE_GIT}" "clone" "--bare" "${DEFAULT_GIT_REMOTE}" "${HOME}/.dotfiles"
# config checkout
execute "${USABLE_GIT}" "--git-dir=${HOME}/.dotfiles/" "--work-tree=${HOME}" "checkout"

# # probably want to
# config config --local status.showUntrackedFiles no

# Setup homebrew
exectue '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

cat <<EOS

${tty_bold}Success 🎉${tty_reset}

for more info check out
- ${tty_bold}https://github.com/saramic/.dotfiles${tty_reset}

EOS
