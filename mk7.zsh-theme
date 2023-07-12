show_timestamp="1"
time_only="0"
date_only="0"
time_first="0"
date_first="1"

function hg_prompt_info {
  if (( $+commands[hg] )) && grep -q "prompt" ~/.hgrc; then
    hg prompt --angle-brackets "\
<hg:%{$fg[magenta]%}<branch>%{$reset_color%}><:%{$fg[magenta]%}<bookmark>%{$reset_color%}>\
</%{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[yellow]%}>%{$reset_color%}>\
%{$fg[red]%}<status|modified|unknown><update>%{$reset_color%}<
patches: <patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied(%{$fg_bold[black]%})|post_unapplied(%{$reset_color%})>>" 2>/dev/null
  fi
}

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}✱"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}➦"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%}✂"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[blue]%}✈"
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}"

function mygit() {
  if [[ "$(git config --get oh-my-zsh.hide-status)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(git_prompt_short_sha)$(git_prompt_status)%{$fg_bold[blue]%}$ZSH_THEME_GIT_PROMPT_SUFFIX "
  fi
}

function git_section() {
  if [[ "$(mygit hg_prompt_info)" > /dev/null ]]; then
    echo "<$(mygit hg_prompt_info)>"
    else echo "$"
  fi
}

function timestamp() {
  local time='%D{'%H:%M:%S'}'
  local date='%D{'%m/%d/%y'}'

  local time_then_date="$time %{$fg[green]%}%{$fg[red]%} \\\ $date"
  local date_then_time="$date%{$fg[green]%}%{$fg[red]%} \\\ $time"

  if [[ "$show_timestamp" = "1" ]]; then
    if [[ "$time_only" = "1" ]]; then
      echo $time
    elif [[ "$date_only" = "1" ]]; then
        echo $date
    else
      if [[ "$date_first" = "1" ]]; then
        echo $date_then_time
        else
          echo $time_then_date
      fi
    fi
    else
      echo "🍆🍒"
  fi
}

function retcode() {}

PROMPT=$'
%{$fg_bold[blue]%}┌─[%{$fg_bold[red]%}%n%b%{$fg[red]%}@%{$fg[cyan]%}%m%{$fg_bold[blue]%}]%{$reset_color%}%{$fg_bold[blue]%} ~ [%{$fg_bold[red]%}%~%{$fg_bold[blue]%}]%{$reset_color%}
%{$fg_bold[blue]%}└─[%{$fg_bold[magenta]%}%F{green}8==D%f%{$fg_bold[blue]%}]%{$fg_bold[red]%} $(git_section)%{$reset_color%} '
# %{$fg_bold[blue]%}└─[%{$fg_bold[magenta]%}%F{green}☺%f%{$fg_bold[blue]%}]%{$fg_bold[red]%} $(git_section)%{$reset_color%} '
RPROMPT=$(timestamp)

PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '
