colorscheme koehler

set mouse=a

set clipboard=

vnoremap y y:call system("wl-copy", getreg('"'))<cr>
