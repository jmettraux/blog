
set viminfo+=n./.viminfo


"
" local shortcuts and co

function! <SID>BlogInsertPreCode()
  normal jo<pre><code class="python"></code></pre>
endfunction " BlogInsertPreCode

nnoremap <silent> <leader>K :call <SID>BlogInsertPreCode()<CR>

