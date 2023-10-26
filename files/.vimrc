set nocompatible
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set textwidth=80
set colorcolumn=+1
set ignorecase
" Zero timeout when escaping visual mode.
set timeoutlen=0
set ttimeoutlen=0

" git commit messages: auto format text to break lines at 72 cols. We have to
" add q (for formatting comments as well) for some reason, otherwise typing in
" the first line messes up the comment below.
au FileType gitcommit set textwidth=72
au FileType gitcommit set formatoptions+=taq
au FileType gitcommit set expandtab

" Highlight trailing whitespaces.
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
au Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL
