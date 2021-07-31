# vim-squint
A plugin to help you visually de-emphasize unimportant code.

# About
I frequently find myself squinting at some code because I only need to focus on
small subset of whatever I'm looking at. Vim has some existing solutions for
this issue, namely folds, but that still requires manually folding all the
things I want to hide, and I also don't actually want to fully hide those
lines, I just want to push them out of my focus. This plugin allows you to
quickly specify a regex, and will apply the "Comment" highlight scheme to any
lines / text that matches that regex, thus effectively de-emphasize all those
unimportant lines by pushing them into the background.

# Installation
If you're using vim-plug, install by adding `Plug 'loganswartz/vim-squint'` to
your vimrc.

# Usage
There are several commands that this plugin makes available:
```vim
:SquintRegex <regex> [<group name> [<squint group name>]]
" Apply the 'Comment' highlight group (or the provided group name) to any text
" that matches the regex.
"
" This command will only apply the highlighting to the exact match of the regex,
" so if you want to de-emphasize any line that contains a match, you'll need to
" either make your regex match the entire line, or more preferably, use the
" 'Squint' convenience form of this function that will do that for you
" automatically.
"
" The group name argument specifies the name that vim-squint will register the
" temporary highlight group under. The string 'vimSquint_' is prepended to all
" names to make sure we're not stepping on other highlight groups. If not
" specified in this or other commands, the group name used is 'default'.

:Squint <regex> [<group name> [<squint group name>]]
" A more convenient form of SquintRegex. This embeds the provided regex into
" another that will make it match the whole line, so you don't have to make
" your regexes match the whole line yourself. All other behavior is identical
" to SquintRegex.

:Unsquint [<group name>]
" Remove a squint group. If a group is not specified, it uses the default group.

:UnsquintAll
" Remove all squint groups.

:SquintList
" List all currently active squint groups.
```
