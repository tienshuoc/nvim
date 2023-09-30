" Syntax setup {{{1
if exists('b:current_syntax') && b:current_syntax == 'list'
  finish
endif

" Syntax: Strings {{{1
syn region  listString    start=+"+  skip=+\\\\\|\\"+  end=+"+  contains=listEscape
syn region  listString    start=+'+  skip=+\\\\\|\\'+  end=+'+  contains=listEscape

" Syntax: JSON Keywords {{{1
" Separated into a match and region because a region by itself is always greedy
syn match  listKeywordMatch /"\([^"]\|\\\"\)\+"[[:blank:]\r\n]*\:/ contains=jsonKeyword

" Syntax: Escape sequences
syn match   listEscape    "\\["\\/bfnrt]" contained
syn match   listEscape    "\\u\x\{4}" contained

" Syntax: Numbers {{{1
syn match   listNumber    "-\=\<\%(0\|[1-9]\d*\)\%(\.\d\+\)\=\%([eE][-+]\=\d\+\)\=\>"
syn keyword listNumber    Infinity -Infinity

" Syntax: An integer part of 0 followed by other digits is not allowed.
syn match   listNumError  "-\=\<0\d\.\d*\>"

" Syntax: Boolean {{{1
syn keyword listBoolean   true false

" Syntax: Null {{{1
syn keyword listNull      null

" Syntax: Braces {{{1
syn match   listBraces     "[{}\[\]]"
syn match   listObjAssign /@\?\%(\I\|\$\)\%(\i\|\$\)*\s*\ze::\@!/

" Syntax: Comment {{{1
syn region  listLineComment    start=+\/\/+ end=+$+ keepend
syn region  listLineComment    start=+^\s*\/\/+ skip=+\n\s*\/\/+ end=+$+ keepend fold
syn region  listComment        start="/\*"  end="\*/" fold
syn match   listComment        '#.*$'

" Define the default highlighting. {{{1
hi def link listString             String
hi def link listObjAssign          Identifier
hi def link listEscape             Special
hi def link listNumber             Number
hi def link listBraces             Operator
hi def link listNull               Function
hi def link listBoolean            Boolean
hi def link listLineComment        Comment
hi def link listComment            Comment
hi def link listNumError           Error
hi def link listKeywordMatch       Label

if !exists('b:current_syntax')
  let b:current_syntax = 'list'
endif
