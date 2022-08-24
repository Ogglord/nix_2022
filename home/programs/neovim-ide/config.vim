'' Oscars extra vim config

  " Show line numbers.
set number            

" no relative
set norelativenumber
set nornu

" close quickfix window
nnoremap <Esc> :q!

" Clear search highlighting
nnoremap <C-z> :nohlsearch<CR>

" Terminal mode exit shortcut
tnoremap <Esc> <C-\><C-n>

" Quick quit w double esc
inoremap <Esc><Esc> <Esc>:q!<CR>
" Quick quit w double esc
noremap <Esc><Esc> :q!<CR>

" Write and exit input mode
imap <C-s> <Esc>:w<CR>