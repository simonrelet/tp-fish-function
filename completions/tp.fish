function __fish_tp_needs_command
  set cmd (commandline -opc)

  if [ (count $cmd) -eq 1 ]
    return 0
  end

  return 1
end

function __fish_tp_using_command
  set cmd (commandline -opc)

  if [ (count $cmd) -gt 1 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end

  return 1
end

complete -f -c tp -s h -l help -d "Display help"
complete -f -c tp -s v -l version -d "Display the script version"
complete -f -c tp -n '__fish_tp_needs_command' -a 'ls' -d "List all jump sites"
complete -f -c tp -n '__fish_tp_needs_command' -a 'add' -d "Add a new jump site"
complete -f -c tp -n '__fish_tp_needs_command' -a 'rm' -d "Remove a jump site"

# DO NOT TOUCH BELOW -- GENERATED PARTS
