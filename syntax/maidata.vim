" Vim syntax file
" Language:	maidata.txt simai chart files
" Author:	WANG Xuerui <git@xen0n.name>
" Copyright:	Copyright (c) 2020 WANG Xuerui
" Licence:	You may redistribute this under the same terms as Vim itself
"
" Syntax highlighting for maidata.txt files. Requires vim 6.3 or later.
"

if &compatible || v:version < 603
    finish
endif

if exists("b:current_syntax")
    finish
endif

" comments
syn match MaidataComment       />>.*$/
syn match MaidataLegacyComment /||.*$/

" escape sequence
syn match MaidataEscape /\\[＆＋％￥]/

" everything not recognized is considered error
syn match MaidataError /[^ \t\r\n&]*/ contained

syn match MaidataUnescapedTokens /[+%\\]/

" recognized variable names
" https://w.atwiki.jp/simai/pages/510.html
syn keyword MaidataVariable contained
    \ title artist first des smsg
    \ amsg_first amsg_time amsg_content
    \ first_1 des_1 smsg_1
    \ first_2 des_2 smsg_2
    \ first_3 des_3 smsg_3
    \ first_4 des_4 smsg_4
    \ first_5 des_5 smsg_5
    \ first_6 des_6 smsg_6
    \ first_7 des_7 smsg_7
    \ nextgroup=MaidataEqualString

syn keyword MaidataLvVariable contained
    \ lv_1
    \ lv_2
    \ lv_3
    \ lv_4
    \ lv_5
    \ lv_6
    \ lv_7
    \ nextgroup=MaidataEqualLv

syn keyword MaidataChartVariable contained
    \ inote_1
    \ inote_2
    \ inote_3
    \ inote_4
    \ inote_5
    \ inote_6
    \ inote_7
    \ nextgroup=MaidataEqualChart

" recognized 2simai (old-fashioned) variable names
" https://w.atwiki.jp/simai/pages/18.html
syn keyword MaidataLegacyVariable contained
    \ freemsg freemsg_1 freemsg_2 freemsg_3 freemsg_4 freemsg_5 freemsg_6 freemsg_7
    \ tap_ofs hold_ofs slide_ofs break_ofs

" key-value structure

syn match MaidataEqualString contained /=/ " nextgroup=MaidataValue

syn match MaidataEqualLv contained /=/ nextgroup=MaidataLv

syn match MaidataEqualChart contained /=/ nextgroup=MaidataChartData

syn match MaidataKeySep contained /&/
    \ nextgroup=MaidataVariable,MaidataLegacyVariable,MaidataLvVariable,MaidataChartVariable,MaidataComment,MaidataLegacyComment,MaidataError

syn region MaidataKeyValue
    \ start=/\ze&/
    \ end=/\ze&/
    \ contains=MaidataKeySep,MaidataComment,MaidataLegacyComment,MaidataError
    \ nextgroup=MaidataKeySep

syn match MaidataLv contained /[0-9]\++\?\|※./

syn region MaidataChartData contained
    \ start=//
    \ end=/\ze&/
    \ contains=MaidataComment,MaidataLegacyComment,MaidataEscape,@MaidataInsn,MaidataError

" instructions
syn match MaidataInsnKey /[1-8]/ contained transparent

syn keyword MaidataInsnDXSensor contained transparent
    \ A1 A2 A3 A4 A5 A6 A7 A8
    \ B1 B2 B3 B4 B5 B6 B7 B8
    \ C C1 C2
    \ D1 D2 D3 D4 D5 D6 D7 D8
    \ E1 E2 E3 E4 E5 E6 E7 E8

syn match MaidataInsnBPM contained /([0-9.]\+)/
syn match MaidataInsnBeatDivisorFrac contained /{[0-9]\+}/
syn match MaidataInsnBeatDivisorAbs contained /{#[0-9.]\+}/
syn cluster MaidataInsn
    \ contains=MaidataInsnBPM,MaidataInsnBeatDivisorAbs,MaidataInsnBeatDivisorFrac

syn match MaidataInsnSepComma contained /,/
syn match MaidataInsnSepEach contained "/"
syn cluster MaidataInsnSep
    \ contains=MaidataInsnSepComma,MaidataInsnSepEach
syn cluster MaidataInsn
    \ add=@MaidataInsnSep

syn match MaidataInsnSepSlideTrack contained /\*/
syn cluster MaidataInsn
    \ add=MaidataInsnSepSlideTrack

syn match MaidataInsnTapSingle contained /[1-8][/,]/
    \ contains=MaidataInsnKey,@MaidataInsnSep
syn cluster MaidataInsn
    \ add=MaidataInsnTapSingle

syn match MaidataInsnTapBreakSingle contained /[1-8]b[/,]/
    \ contains=MaidataInsnKey,@MaidataInsnSep
syn cluster MaidataInsn
    \ add=MaidataInsnTapBreakSingle

syn match MaidataInsnTouchSingle contained /[A-E][1-8][/,]/
    \ contains=MaidataInsnDXSensor,@MaidataInsnSep
syn cluster MaidataInsn
    \ add=MaidataInsnTouchSingle

syn match MaidataInsnTapMulti contained /[1-8]\+,/
    \ contains=MaidataInsnKey,MaidataInsnSepComma
syn cluster MaidataInsn
    \ add=MaidataInsnTapMulti

syn region MaidataInsnDuration contained
    \ start=/\[/
    \ end=/\]/
    \ contains=MaidataInsnDurationParam,@MaidataInsnDurationParamSpecial
    \ transparent

" TODO: refine this
syn match MaidataInsnDurationParam contained /[0-9]\+:[0-9]\+/ transparent
syn match MaidataInsnDurationParamSpecialA contained /#[0-9.]\+/
syn match MaidataInsnDurationParamSpecialB contained /[0-9.]\+#[0-9]\+:[0-9]\+/
syn match MaidataInsnDurationParamSpecialC contained /[0-9.]\+##[0-9.]\+/
syn cluster MaidataInsnDurationParamSpecial
    \ contains=MaidataInsnDurationParamSpecialA,MaidataInsnDurationParamSpecialB,MaidataInsnDurationParamSpecialC

syn match MaidataInsnHold contained /[1-8]h\[[#0-9:.]\+\][/,]/
    \ contains=MaidataInsnDuration,@MaidataInsnSep
syn cluster MaidataInsn
    \ add=MaidataInsnHold

syn match MaidataInsnSlideShapeOther contained /pp\|qq\|[<>^vpqszw-]/
syn match MaidataInsnSlideShapeV contained /V/
syn cluster MaidataInsnSlideShape
    \ contains=MaidataInsnSlideShapeOther,MaidataInsnSlideShapeV

syn match MaidataInsnSlideStartTap contained /[1-8]\ze[<>^vpqszwV-]/
syn match MaidataInsnSlideStartBreak contained /[1-8]b\ze[<>^vpqszwV-]/
syn cluster MaidataInsnSlideStart
    \ contains=MaidataInsnSlideStartTap,MaidataInsnSlideStartBreak

syn match MaidataInsnSlideTrackOther contained /[<>^vpqszw-][pq]\?[1-8]\[[#0-9:.]\+\][*/,]/
    \ contains=@MaidataInsnSlideShape,MaidataInsnDuration,@MaidataInsnSep,MaidataInsnSepSlideTrack
syn match MaidataInsnSlideTrackV contained /V[1-8][1-8]\[[#0-9:.]\+\][*/,]/
    \ contains=@MaidataInsnSlideShape,MaidataInsnDuration,@MaidataInsnSep,MaidataInsnSepSlideTrack
syn cluster MaidataInsn
    \ add=@MaidataInsnSlideStart,MaidataInsnSlideTrackOther,MaidataInsnSlideTrackV

" sync at & signs at beginning of line
syn sync match MaidataSync grouphere NONE /^&/

hi def link MaidataComment                 Comment
hi def link MaidataLegacyComment           Comment
hi def link MaidataEscape                  Special
hi def link MaidataError                   Error
hi def link MaidataUnescapedTokens         Error
hi def link MaidataVariable                Identifier
hi def link MaidataLegacyVariable          Special
hi def link MaidataLvVariable              Identifier
hi def link MaidataChartVariable           Identifier
hi def link MaidataKeySep                  Comment
hi def link MaidataEqualString             Operator
hi def link MaidataEqualLv                 Operator
hi def link MaidataEqualChart              Operator
hi def link MaidataKey                     Define
hi def link MaidataLv                      Number

"hi def link MaidataInsnKey                 Keyword
"hi def link MaidataInsnDXSensor            Identifier
hi def link MaidataInsnBPM                 Macro
hi def link MaidataInsnBeatDivisorAbs      Special
hi def link MaidataInsnBeatDivisorFrac     Macro
hi def link MaidataInsnSepComma            Comment
hi def link MaidataInsnSepEach             Special
hi def link MaidataInsnSepSlideTrack       Special
hi def link MaidataInsnTapSingle           String
hi def link MaidataInsnTapBreakSingle      Todo
hi def link MaidataInsnTouchSingle         Identifier
hi def link MaidataInsnTapMulti            String
hi def link MaidataInsnDurationParamSpecialA MaidataInsnDurationParamSpecial
hi def link MaidataInsnDurationParamSpecialB MaidataInsnDurationParamSpecial
hi def link MaidataInsnDurationParamSpecialC MaidataInsnDurationParamSpecial
hi def link MaidataInsnDurationParamSpecial  Special
hi def link MaidataInsnHold                Repeat
hi def link MaidataInsnSlideShapeOther     Type
hi def link MaidataInsnSlideShapeV         Type
hi def link MaidataInsnSlideStartTap       Underlined
hi def link MaidataInsnSlideStartBreak     Todo
hi def link MaidataInsnSlideTrackOther     Underlined
hi def link MaidataInsnSlideTrackV         Underlined

let b:current_syntax = "maidata"
