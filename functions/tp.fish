function tp --description 'Teleport through folders'
  set version "1.1.0"

  function tp_clean_functions
    functions -e tp_usage
    functions -e tp_ls
    functions -e tp_add
    functions -e tp_rm
    functions -e tp_tp
    functions -e tp_clean_functions
  end

  function tp_usage
    printf "Usage: tp [options]\n"
    printf "       tp <jump-site>\n"
    printf "       tp { ls | add | rm }\n\n"
    printf "A teleportation tool. Use the <TAB> key to toggle the awesome completion.\n\n"
    printf "Options:\n"
    printf "  -h, --help     Display this help.\n"
    printf "  -v, --version  Display the script version.\n\n"
    printf "Commands:\n"
    printf "  ls                 List all the jump sites.\n"
    printf "  add [<jump-site>]  Add a new jump site for the current location. The jump site\n"
    printf "                     name is either the current folder's name or <jump-site> if\n"
    printf "                     given. If one already exists with the same name, an error\n"
    printf "                     message is displayed.\n"
    printf "  rm <jump-site>     Remove <jump-site>. After this command, you wont be\n"
    printf "                     able to teleport their any more. You've been warned.\n"

    tp_clean_functions
  end

  function tp_ls
    set sites (cat ~/.config/fish/completions/tp.fish | grep "JUMP-SITE-INFO")
    if test -n "$sites"
      printf "Jump sites:\n\n"

      for p in $sites
        set site (echo "$p" | sed -E "s/.*: (.*);.*/\1/g")
        set url (echo "$p" | sed -E "s/.*: .*;(.*)/\1/g")

        set_color blue
        printf "  %s" "$site"
        set_color normal
        printf "  ->  %s\n" "$url"
      end

      printf "\n"
    else
      printf "No jump sites yet\n"
    end

    tp_clean_functions
  end

  function tp_add
    set tmp (count $argv)
    set site_name (basename (pwd))
    if [ $tmp = 2 ]
      set site_name $argv[2]
    end

    set tmp (pwd)
    for p in (cat ~/.config/fish/completions/tp.fish | grep "JUMP-SITE-INFO")
      set site (echo "$p" | sed -E "s/.*: (.*);.*/\1/g")
      set url (echo "$p" | sed -E "s/.*: .*;(.*)/\1/g")

      if [ "$site" = "$site_name" ]
        printf "Sorry, the jump site '"
        set_color red
        printf "%s" "$site_name"
        set_color normal
        printf "' already exists:\n\n"
        set_color blue
        printf "  %s" "$site"
        set_color normal
        printf "  ->  %s\n\n" "$url"
        tp_clean_functions
        return 1
      end
    end

    printf "# JUMP-SITE-INFO: %s;%s\n" $site_name $tmp >> ~/.config/fish/completions/tp.fish
    printf "complete -f -c tp -n '__fish_tp_needs_command' -a '%s' -d '%s' # JUMP-SITE-FOR: %s\n" $site_name $tmp $site_name >> ~/.config/fish/completions/tp.fish
    printf "complete -f -c tp -n '__fish_tp_using_command rm' -a '%s' -d '%s' # JUMP-SITE-FOR: %s\n" $site_name $tmp $site_name >> ~/.config/fish/completions/tp.fish

    printf "Added a new jump site:\n\n"
    set_color blue
    printf "  %s" "$site_name"
    set_color normal
    printf "  ->  %s\n\n" "$tmp"
    tp_clean_functions
  end

  function tp_rm
    set tmp (count $argv)
    if [ $tmp != 2 ]
      set_color red
      printf "Uh... which jump site do you want to remove?\n\n"
      set_color normal
      tp_usage
      return 1
    end

    set tmp (cat ~/.config/fish/completions/tp.fish | grep "JUMP-SITE-INFO: $argv[2]")
    if test -n $tmp
      set site (echo "$tmp" | sed -E "s/.*: (.*);.*/\1/g")
      set url (echo "$tmp" | sed -E "s/.*: .*;(.*)/\1/g")
      sed -n "/# JUMP-SITE-.*: $site/!p" ~/.config/fish/completions/tp.fish > ~/.config/fish/completions/tp.fish2
      mv ~/.config/fish/completions/tp.fish2 ~/.config/fish/completions/tp.fish

      printf "Removed the jump site:\n\n"
      set_color blue
      printf "  %s" "$site"
      set_color normal
      printf "  ->  %s\n\n" "$url"
    end
    tp_clean_functions
  end

  function tp_tp
    set tmp (cat ~/.config/fish/completions/tp.fish | grep "JUMP-SITE-INFO: $argv[1]")
    if test -n $tmp
      set url (echo "$tmp" | sed -E "s/.*: .*;(.*)/\1/g")
      cd $url
      tp_clean_functions
      return 0
    end
    printf "Unknown jump site '"
    set_color red
    printf "%s" "$argv"
    set_color normal
    printf "'.\n"
    tp_clean_functions
    return 1
  end

  begin
    set tmp (count $argv)
    if [ $tmp = 0 ]
      tp_usage
      return 1
    end
  end

  switch $argv[1]
  case -h --help
    tp_usage
    return 0

  case -v --version
    printf "%s\n" $version
    return 0

  case ls
    tp_ls
    return 0

  case add
    tp_add $argv

  case rm
    tp_rm $argv

  case '*'
    tp_tp $argv
  end
end
