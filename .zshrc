# echo with color
echoC() {
  if [ "$1" = "-n" ]; then
    local no_newline="-n"
    shift
  fi

  local color_code="$1"
  shift
  
  echo -e $no_newline "\033[0;${color_code}m$@\033[0m"
}


# set gpg global commit sign flag
gpgf() {
  echo "Current GPG global commit sign flag: $(git config --global commit.gpgsign)"
  echo "Select an action:"
  echo "1. Set true"
  echo "2. Unset"
  echo -n "Enter the number of the action: "
  read action
  case $action in
    1)
      git config --global commit.gpgsign true
      echo "GPG global commit sign flag set to true."
      ;;
    2)
      git config --global --unset commit.gpgsign
      echo "GPG global commit sign flag unset"
      ;;
    *)
      echo "Invalid action. Please enter 1 or 2."
      ;;
  esac
}

# set git gpg user sign key
gpgs() {
  keys=($(gpg --list-keys --keyid-format SHORT | grep '^pub' | awk '{print $2}' | sed 's/^[^/]*\///'))
  
  emails=()
  comments=()
  
  gpg --list-keys | grep '^uid' | while IFS= read -r line; do
    # 提取 email
    email=$(echo $line | grep -o '<[^>]*>' | sed 's/[<>]//g')
    if ([ -n "$email" ]); then
      emails+=($email)
    else
      emails+=("")
    fi
    
    # 提取 comment
    comment=$(echo $line | grep -o '([^)]*)')
    if [[ -n "$comment" ]]; then
      comment=$(echo $comment | sed 's/[()]//g')
      comments+=($comment)
    else
      comments+=("")
    fi
  done

  if [ ${#keys[@]} -eq 0 ]; then
    echoC "31" "No GPG keys found. Please create a key first."
    return 1
  fi
  
  echo "Available GPG keys:"
  for i in {1..$#keys}; do
    if [ -n "${comments[$i]}" ]; then
      echoC "34" "$i. ${keys[$i]} (${emails[$i]}) - ${comments[$i]}"
    else
      echoC "34" "$i. ${keys[$i]} (${emails[$i]})"
    fi
  done

  echoC -n "33" "Enter the number of the GPG key to set as your signing key: "
  read choice
  if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le $#keys ]; then
    echo "Your selected key is: ${keys[$choice]}"
  else
    echoC "31" "Invalid choice. Please enter the valid number 1 to ${#keys[@]}."
    return 1
  fi

  echo "Select an action:"
  echo "1. Set signing key"
  echo "2. Delete GPG key"
  echoC -n "33" "Enter the number of the action: "
  read action
  case $action in
    1)
      git config --global user.signingkey ${keys[$choice]}
      echo "GPG key ${keys[$choice]} set as your signing key."
      ;;
    2)
      gpg --delete-secret-keys ${keys[$choice]}
      gpg --delete-key ${keys[$choice]}
      echo "GPG key ${keys[$choice]} deleted."
      ;;
    *)
      echoC "31" "Invalid action. Please enter 1 or 2."
      ;;
  esac
}