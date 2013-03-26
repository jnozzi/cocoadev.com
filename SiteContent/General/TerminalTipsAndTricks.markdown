To reveal the current working directory in the Finder, type <code>open .</code>

open is very practical, <code>open <file></code> will simulate a doubleclick, but one can also do e.g. <code>open http://apple.com </code> to open that page (in the default browser), and one can also specify the application to use, e.g. <code>open -a VLC someMovie.avi</code> to open the movie with VLC.

pbpaste will dump the contents of the pasteboad and pbcopy will read from stdin and place that on the pasteboard.

Unfortunately the shell starts all commands in a pipe-sequence simultaneously so <code>pbpaste | sed ... | pbcopy</code> will fail, but one can delay the pbcopy like this <code>pbpaste | expand -3 >/tmp/crap && pbcopy </tmp/crap</code>.

Or, if you do it a lot, in tcsh create an alias like
<code>
alias pbfilter 'pbpaste | \!'' >/tmp/crap && pbcopy </tmp/crap'
</code>
or in bash, a function a la:
<code>
pbfilter() { pbpaste | $'' >/tmp/crap; pbcopy </tmp/crap; }
</code>

Cmd-Ctrl-V pastes escaped text from the pasteboard.

Cmd-Shift-V pastes the current selection (w/o placing it on the pasteboard).