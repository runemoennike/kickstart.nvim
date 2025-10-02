GuiTabline 0

" Set Editor Font
if exists(':GuiFont')
	let s:fontsize = 12
	function! AdjustFontSize(amount)
	  let s:fontsize = s:fontsize+a:amount
	  :execute "GuiFont! FiraCode Nerd Font:h" . s:fontsize
	endfunction

	noremap <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
	noremap <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
	inoremap <C-ScrollWheelUp> <Esc>:call AdjustFontSize(1)<CR>a
	inoremap <C-ScrollWheelDown> <Esc>:call AdjustFontSize(-1)<CR>a
	
	call AdjustFontSize(0)
endif

" Enable Mouse
set mouse=a

" Disable GUI Tabline
if exists(':GuiTabline')
    GuiTabline 0
endif

" Disable GUI Popupmenu
if exists(':GuiPopupmenu')
    GuiPopupmenu 0
endif

" Enable GUI ScrollBar
if exists(':GuiScrollBar')
    GuiScrollBar 0
endif