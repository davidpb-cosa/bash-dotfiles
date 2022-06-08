#
#!/bin/zsh
#

# Print shell main title
function title () {
  local message=${(V)1//\%/\%\%}
  message=$(print -Pn "%40>...>$a" | tr -d "\n")

  case $TERM in
    screen) print -Pn "\ek$message:$3\e\\" ;;
    xterm*|rxvt) print -Pn "\e]2;$2\a" ;;
  esac
}