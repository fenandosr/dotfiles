#!/usr/bin/env bash

#
# Sources:
#   https://github.com/jdavis/dotfiles/
#   https://github.com/tmux-plugins/tmux-sensible
#

is_osx() {
	local platform=$(uname)
	[ "$platform" == "Darwin" ]
}

iterm_terminal() {
	[[ "$TERM_PROGRAM" =~ ^iTerm ]]
}

command_exists() {
	local command="$1"
	type "$command" >/dev/null 2>&1
}

# returns prefix key, e.g. 'C-a'
prefix() {
	tmux show-option -gv prefix
}

# if prefix is 'C-a', this function returns 'a'
prefix_without_ctrl() {
	local prefix="$(prefix)"
	echo "$prefix" | cut -d '-' -f2
}

option_value_not_changed() {
	local option="$1"
	local default_value="$2"
	local option_value=$(tmux show-option -gv "$option")
	[ "$option_value" == "$default_value" ]
}

server_option_value_not_changed() {
	local option="$1"
	local default_value="$2"
	local option_value=$(tmux show-option -sv "$option")
	[ "$option_value" == "$default_value" ]
}

key_binding_not_set() {
	local key="$1"
	if $(tmux list-keys | grep -q "${KEY_BINDING_REGEX}${key}[[:space:]]"); then
		return 1
	else
		return 0
	fi
}

key_binding_not_changed() {
	local key="$1"
	local default_value="$2"
	if $(tmux list-keys | grep -q "${KEY_BINDING_REGEX}${key}[[:space:]]\+${default_value}"); then
		# key still has the default binding
		return 0
	else
		return 1
	fi
}

# If reattach-to-user-namespace is not available, just run the command.
if is_osx && command_exists "reattach-to-user-namespace" && option_value_not_changed "default-command" ""; then
  tmux set-option -g default-command "reattach-to-user-namespace -l $SHELL"
else
  exec "$@"
fi
