function! GetVisualSelection()
    if mode()=="v"
        let [line_start, column_start] = getpos("v")[1:2]
        let [line_end, column_end] = getpos(".")[1:2]
    else
        let [line_start, column_start] = getpos("'<")[1:2]
        let [line_end, column_end] = getpos("'>")[1:2]
    end

    if (line2byte(line_start)+column_start) > (line2byte(line_end)+column_end)
        let [line_start, column_start, line_end, column_end] =
        \   [line_end, column_end, line_start, column_start]
    end
    let lines = getline(line_start, line_end)
    if len(lines) == 0
            return ['']
    endif
    if &selection ==# "exclusive"
        let column_end -= 1 "Needed to remove the last character to make it match the visual selction
    endif
    if visualmode() ==# "\<C-V>"
        for idx in range(len(lines))
            let lines[idx] = lines[idx][: column_end - 1]
            let lines[idx] = lines[idx][column_start - 1:]
        endfor
    else
        let lines[-1] = lines[-1][: column_end - 1]
        let lines[ 0] = lines[ 0][column_start - 1:]
    endif
   " echo lines
    return lines
    "use this return if you want an array of text lines
    " return join(lines, "\n") "use this return instead if you need a text block
endfunction

" Log a message
function! Log(message)
  " Bail if not logging
 " if g:codi#log ==# '' | return | endif

  " Grab stack trace not including log function
  let stacktrace = expand('<sfile>')
  let stacktrace = stacktrace[0:strridx(stacktrace, '..') - 1]

  " Remove everything except the last function
  let i = strridx(stacktrace, '..')
  if i != -1
    let fname = stacktrace[i + 2:]
  else
    " Strip 'function '
    let fname = stacktrace[9:]
  endif

  " Create timestamp with microseconds
  let seconds_and_microseconds = reltimestr(reltime())
  let decimal_i = stridx(seconds_and_microseconds, '.')
  let seconds = seconds_and_microseconds[:decimal_i - 1]
  let microseconds = seconds_and_microseconds[decimal_i + 1:]
  let timestamp = strftime('%T.'.microseconds, seconds)

  " Write to log file
  call writefile(['['.timestamp.'] '.fname.': '.a:message],
        \ '/home/f1/logs/nvim.log', 'a')
endfunction

command! -bang -nargs=? Fd
  \ call fzf#run(fzf#wrap({
  \   'source': printf('echo %s; fd --color=always %s', shellescape('$ fd ' . <q-args>), shellescape(<q-args>)),
  \   'options': '--reverse --bind "ctrl-p:reload(echo mode 2; fd --color=always -uu)" --header-lines 1',
  \   'sink': 'e'},
  \   <bang>0))
