-- https://github.com/nvim-telescope/telescope.nvim/pull/494/files
-- https://github.com/nvim-telescope/telescope.nvim/blob/a77b3255cb9122594bd60513d64dbb17e4f41dc2/lua/telescope/utils.lua
--------------------------------------------------------
local utils = {}


        utils.strdisplaywidth = (function()
          if jit then
            local ffi = require('ffi')
            ffi.cdef[[
            typedef unsigned char char_u;
            int linetabsize_col(int startcol, char_u *s);
            ]]

            return function(str, col)
              local startcol = col or 0
              local s = ffi.new('char[?]', #str + 1)
              ffi.copy(s, str)
              return ffi.C.linetabsize_col(startcol, s) - startcol
            end
          else
            return function(str, col)
              return #str - (col or 0)
            end
          end
        end)()

        utils.utf_ptr2len = (function()
          if jit then
            local ffi = require('ffi')
            ffi.cdef[[
            typedef unsigned char char_u;
            int utf_ptr2len(const char_u *const p);
            ]]

            return function(str)
              local c_str = ffi.new('char[?]', #str + 1)
              ffi.copy(c_str, str)
              return ffi.C.utf_ptr2len(c_str)
            end
          else
            return function(str)
              return str == '' and 0 or 1
            end
          end
        end)()

        function utils.strcharpart(str, nchar, charlen)
          local nbyte = 0
          if nchar > 0 then
            while nchar > 0 and nbyte < #str do
              nbyte = nbyte + utils.utf_ptr2len(str:sub(nbyte + 1))
              nchar = nchar - 1
            end
          else
            nbyte = nchar
          end

          local len = 0
          if charlen then
            while charlen > 0 and nbyte + len < #str do
              local off = nbyte + len
              if off < 0 then
                len = len + 1
              else
                len = len + utils.utf_ptr2len(str:sub(off + 1))
              end
              charlen = charlen - 1
            end
          else
            len = #str - nbyte
          end

          if nbyte < 0 then
            len = len + nbyte
            nbyte = 0
          elseif nbyte > #str then
            nbyte = #str
          end
          if len < 0 then
            len = 0
          elseif nbyte + len > #str then
            len = #str - nbyte
          end

          return str:sub(nbyte + 1, nbyte + len)
        end


        -- Get position for passed registers
        -- @param start_register table see help :getpos
        -- @param end_register table see help :getpos
        -- @param exit_visual_mode boolean whether to exit visual mode
        function utils.get_pos(start_register, end_register, exit_visual_mode)
          exit_visual_mode = exit_visual_mode or true
          local mode = vim.api.nvim_get_mode().mode

          -- get {start: 'v', end: curpos} of visual selection 0-indexed
          local l_start, c_start = unpack(vim.fn.getpos(start_register), 2, 3)
          local l_end, c_end = unpack(vim.fn.getpos(end_register), 2, 3)

          if exit_visual_mode then
            vim.cmd [[normal :esc<CR>]]
          end

          -- Resolution via wincol (see :help wincol) enables reconstruction of blockwise selection
          local wincol_start, wincol_end, wincol_left, wincol_right, c_flip, l_flip
          if mode == '' then
            wincol_start = utils.get_wincol({l_start, c_start - 1}, {l_start, c_start - 1})
            wincol_end = utils.get_wincol({l_end, c_end - 1}, {l_start, c_start -1 })
            -- backwards visual selection
            -- visual-block mode switch only after getting wincol column edges!
            if l_start > l_end then
              l_end, l_start = l_start, l_end
              l_flip = true
            end
            if c_start > c_end then
              c_end, c_start = c_start, c_end
              c_flip = true
            end
            -- Blockwise selection requires the very most edge wincol
            -- Consider a multi-width char: 全, wincol solely returns the first visual column though char occupies 2 cols
            -- edge_wincol returns the left or right border wincol instead depending on 'maximum' param
            -- get edge pos for wincol start (most left) and end (most right) by line from original positions
            -- flipping is required to know what direction to resolve to
            wincol_start = utils.edge_wincol({l_flip and l_end or l_start,          -- get l_end if flipped else original l_start
            c_flip and c_end - 1 or c_start - 1},  -- get c_end if flipped else original c_start
            wincol_start,                            -- resolve for wincol_start
            c_flip)                                -- flipped (true) or not (false), resolve to true=right, left=false
            wincol_end = utils.edge_wincol({l_flip and l_start or l_end,            -- resolve conversely in opposite direction as above
            c_flip and c_start - 1 or c_end - 1},
            wincol_end,
            not c_flip)
            -- properly set left and right edge wincol
            wincol_left = math.min(wincol_start, wincol_end)
            wincol_right = math.max(wincol_start, wincol_end)
            return l_start, c_start, l_end, c_end, wincol_left, wincol_right
          else
            -- char- or linewise selection
            if l_start > l_end or (l_start == l_end and c_end < c_start) then
              return l_end, c_end, l_start, c_start
            end
            return l_start, c_start, l_end, c_end
          end
        end

        -- Retrieve wincol from pos
        -- wincol (see :help wincol) denotes the visual column of the current cursor position
        -- Since wincol can only be retrieved for the current position,
        -- the cursor has to be set prior
        -- @param pos table position to retrieve wincol for
        -- @param start_pos table optional position to jump back to
        function utils.get_wincol(pos, start_pos)
          start_pos = start_pos or false
          -- pos {line, col} - {1, 0}-indexed
          vim.api.nvim_win_set_cursor(0, pos)

          local wincol = vim.fn.wincol()
          if start_pos then
            vim.api.nvim_win_set_cursor(0, start_pos)
          end
          return wincol
        end

        -- Get maximum, possibly synthetic wincol for position
        -- Consider a multi-width char: 全, wincol solely returns the first visual column
        -- edge_wincol returns the left or right border wincol instead depending on parameters
        -- @param pos table {row, column} with {1, 0} indexed values
        -- @param wincol integer initial wincol prior to finding (synthetic) maximum
        -- @param maximum boolean true resolves towards right, false resolves towards left
        function utils.edge_wincol(pos, wincol, maximum)
          maximum = maximum or false
          local max_col = utils.get_wincol({pos[1], 2^31-1})
          if wincol >= max_col then
            return max_col
          end
          if wincol == 1 then
            return 1
          end

          local newcol = utils.get_wincol(pos)
          if maximum then
            if newcol > wincol then
              return newcol - 1
            else
              return utils.edge_wincol({pos[1], pos[2] + 1}, wincol, true)
            end
          else
            if newcol < wincol then
              return newcol + 1
            elseif newcol == wincol then
              return wincol
            else
              return utils.edge_wincol({pos[1], pos[2] - 1}, wincol, false)
            end
          end
        end

        -- Greedily get closest byte column left {true} or right {left=false} from passed wincol
        -- Once edge wincol for blockwise selection are found, this function finds
        -- closest or match byte column in terms of starting pos and direction
        -- Returns byte column zero indexed
        -- Note: greedy resolution is performed as recursion would otherwise require difficult/opaque edge cases to catch
        -- @param wincol integer wincol to get closest or equal byte column for
        -- @param pos table {row and column} {1, 0}-index of position to resolve
        -- @param line_len integer length of line in byte columns, zero-indexed (lua string length - 1)
        -- @param left boolean approximate or match wincol from left (true, ~max) or from right (false, ~min)
        function utils.greedy_wincol_byte(wincol, pos, line_len, left)
          left = left or false
          local max_col = utils.get_wincol({pos[1], 2^31-1})

          if left then
            if wincol > max_col then
              return line_len
            end
            for i=0,line_len do
              local wcol = utils.get_wincol({pos[1], i})
              if wcol == wincol then
                return i
              end
              if wcol > wincol then
                return i - 1
              end
            end
          else
            if wincol > max_col then
              return nil
            end
            for i=line_len,0,-1 do
              local wcol = utils.get_wincol({pos[1], i})
              if wcol <= wincol then
                return i
              end
            end

          end
        end

        -- Recursively resolve beginning or ending byte column for multi-width characters
        --  Example: multi-width Japanese Zenkaku, see change in columns from left to right char
        --  全角
        -- For 全 above and offset=1, resolve_bytecol returns 7
        -- vim.str_byteindex is similar though can only return the right-hand border
        -- Note: byte columns are 1-indexed for simplified interop with lua string:sub
        -- @param line string: buffer line
        -- @param byte_col integer: initial byte column
        -- @param offset integer: resolver char border towards char beginning (-1) or char end (+1)
        -- return byte_col integer: byte column of char beginning or end
        function utils.resolve_bytecol(line, byte_col, offset)
          local utf_start, _ = vim.str_utfindex(line, math.min(byte_col, #line))
          local utf_start_offset, _ = vim.str_utfindex(line, math.min(byte_col + offset, #line))
          if utf_start == utf_start_offset and byte_col + offset <= #line and byte_col + offset >= 0 then
            return utils.resolve_bytecol(line, byte_col + offset, offset)
          else
            return byte_col
          end
        end

        function utils.get_visual_selection(return_table, delimiter, trim, exit_visual_mode)
          return_table = return_table or false 
          delimiter = delimiter or ' '
          trim = trim or true
          exit_visual_mode = exit_visual_mode or ' '

          local mode = vim.api.nvim_get_mode().mode
          local line_start, column_start, line_end, column_end, wincol_start, wincol_end = utils.get_pos("v", ".", exit_visual_mode)
          local lines = vim.api.nvim_buf_get_lines(0, line_start - 1, line_end, false)

          local concat = {}
          local first_line = 1
          local last_line = line_end - (line_start - 1)
          if first_line == last_line then
            -- get difference in columns, inclusive
            column_end =  column_end - column_start + 1
          end
          for row=first_line,last_line do
            local line = lines[row]
            if line ~= "" then
              if mode ~= 'V' then
                local start_bytecol
                if row == first_line or mode == '' then
                  if mode == ''  then
                    -- Iterate from end of line to get maximum byte col for which wincol >= wincol_start
                    start_bytecol = utils.greedy_wincol_byte(wincol_start,
                    {line_start + row - 1, column_start - 1},
                    #lines[row]-1,
                    false)
                    -- wincol_start is beyond line
                    if start_bytecol ~= nil then
                      start_bytecol = start_bytecol + 1
                      start_bytecol = utils.resolve_bytecol(line, start_bytecol, -1)
                    else
                      start_bytecol = #line + 1 -- clear out line
                    end

                  else
                    -- Recursively get first byte index of utf char for initial byte column selection
                    --  Example: multi-width Japanese Zenkaku, see change in columns from left to right char
                    --  全角
                    start_bytecol = utils.resolve_bytecol(line, column_start, -1)
                  end
                  line = line:sub(start_bytecol)
                end
                if row == last_line or mode == '' and line ~= '' then
                  local end_bytecol
                  if mode == '' then
                    -- Iterate from beginning of line to get maximum byte col for which wincol <= wincol_end
                    end_bytecol = utils.greedy_wincol_byte(wincol_end,{line_start + row - 1, column_end - 1}, #lines[row]-1, true)
                    -- get difference in byte offset inclusive and add back zero indexing
                    -- (difference here means absolute position after cutoff)
                    - start_bytecol + 2
                  end
                  -- Recursively get last byte index of utf char for last byte column selection
                  end_bytecol = utils.resolve_bytecol(line, end_bytecol or column_end, 1)
                  line = line:sub(1, math.min(end_bytecol, #line))
                end
              end
            end
            if trim then
              line = vim.trim(line)
            end
            table.insert(concat, line)
            if mode == '' then
              vim.api.nvim_win_set_cursor(0, {line_start, column_start - 1})
            end
          end
          if return_table then
          return concat
          else 
           table.concat(concat, delimiter)
         end
        end

        return utils
