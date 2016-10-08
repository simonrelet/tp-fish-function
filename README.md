# tp-fish-function

> A folder teleportation function for [Fish](http://fishshell.com/) shell.

## Example

```sh
$ cd /path/to/my/awesome/project
$ tp add
Added a new jump site:

  project  ->  /path/to/my/awesome/project

$ cd
$ tp project
$ pwd
/path/to/my/awesome/project
```

## Installation

```sh
curl -o ~/.config/fish/functions/tp.fish --create-dirs https://raw.githubusercontent.com/simonrelet/tp-fish-function/master/functions/tp.fish
curl -o ~/.config/fish/completions/tp.fish --create-dirs https://raw.githubusercontent.com/simonrelet/tp-fish-function/master/completions/tp.fish
```

**With [Fisherman](https://github.com/fisherman/fisherman)**

```sh
fisher install simonrelet/tp-fish-function
```

## Usage

```
Usage: tp [options]
       tp <jump-site>
       tp { ls | add | rm }

A teleportation tool. Use the <TAB> key to toggle the awesome completion.

Options:
  -h, --help     Display this help.
  -v, --version  Display the script version.

Commands:
  ls                 List all the jump sites.
  add [<jump-site>]  Add a new jump site for the current location. The jump site
                     name is either the current folder's name or <jump-site> if
                     given. If one already exists with the same name, an error
                     message is displayed.
  rm <jump-site>     Remove <jump-site>. After this command, you wont be
                     able to teleport their any more. You've been warned.
```

## License

MIT.
