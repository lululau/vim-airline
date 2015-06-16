" MIT License. Copyright (c) 2013-2015 Bailey Ling.
" vim: et ts=2 sts=2 sw=2

let s:number_map = &encoding == 'utf-8'
      \ ? {
      \ '0': '⁰',
      \ '1': '¹',
      \ '2': '²',
      \ '3': '³',
      \ '4': '⁴',
      \ '5': '⁵',
      \ '6': '⁶',
      \ '7': '⁷',
      \ '8': '⁸',
      \ '9': '⁹'
      \ }
      \ : {}


function! airline#extensions#tabline#formatters#unique_tail#format(bufnr, buffers)
  let s:buf_index = index(a:buffers, a:bufnr) + 1
  if s:buf_index > 9 && s:buf_index == len(a:buffers)
    let s:buf_index = 0
  endif
  let s:buf_index = get(s:number_map, s:buf_index . '', '')
  let duplicates = {}
  let tails = {}
  let map = {}
  for nr in a:buffers
    let name = bufname(nr)
    if empty(name)
      let map[nr] = s:buf_index . '[No Name]'
    else
      let tail = s:buf_index . fnamemodify(name, ':t')
      if has_key(tails, tail)
        let duplicates[nr] = nr
      endif
      let tails[tail] = 1
      let map[nr] = airline#extensions#tabline#formatters#default#wrap_name(nr, tail)
    endif
  endfor

  for nr in values(duplicates)
    let map[nr] = airline#extensions#tabline#formatters#default#wrap_name(nr, fnamemodify(bufname(nr), ':p:.'))
  endfor

  if has_key(map, a:bufnr)
    return map[a:bufnr]
  endif

  " if we get here, the buffer list isn't in sync with the selected buffer yet, fall back to the default
  return airline#extensions#tabline#formatters#default#format(a:bufnr, a:buffers)
endfunction
