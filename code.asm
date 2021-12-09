START			EQU	#c000
SCREEN			EQU	#4000
effectstart     equ 100
effectend       equ 155
				ORG	START
				di
				LD	SP,START-1

				ld a,0
				out (#fe),a

				ld hl,#4000
				ld (hl),a
				ld de,#4001
				ld bc,#1b00
				ldir		

				ld de,#4000				
				ld hl,circle1
				call fillpattern
				ld hl,circle
				call fillpattern
				ld hl,circle1				
				call fillpattern
cycle
				ei
				halt
				di

				ld a,(counter)
				or a
				jr nz, cycle2
				ld de,0
cycle2
				inc a
				ld (counter),a
				cp effectstart
				jr nz, skipcorrection
				ld a,-64
				ld (copyline2+2),a
skipcorrection
				cp effectend
				jr nz,skipcorrection2
				ld a,-32
				ld (copyline2+2),a
skipcorrection2
				ld b,236
wait
				ld a,(iy+1)
				djnz wait				
;----------------------------------------------
scroll
				ld a,(counter)
				cp effectstart
				jr c,skipeffect
				cp effectend
				jr nc,skipeffect
				ld a,(copyline2+2)
				inc a
				ld (copyline2+2),a
skipeffect
				ld c,11
				ld ix,#5800+32
scrollline
				ld b,32
copyline
				ld a,(ix)
copyline2				
				ld (ix-32),a
				inc ix
				djnz copyline
				dec c
				jr nz,scrollline

				exx
				ld a,#ff
				ld hl,#57e0
				ld (hl),a
				ld de,#57e1
				ld bc,31
				ldir
				exx
;----------------------------------------------

startdraw
;read length
				ld a,(de)
				inc de
				and %00001111
				inc a
;min length=1
				ld b,a
				
				ld c,a
				ld a,16
				sub c
				ld c,a

				ld a,b
				ld hl,#5980 - 16
;read color
				ld a,(de)
				inc de
				and %00111000
				set 6,a
drawline
				or a
				jr z,skipcolor
				srl a
				srl a
				srl a
				dec a
				add a,a
				add a,a
				add a,a
skipcolor
				ld (hl),a
				inc hl
				djnz drawline

				ld a,c
				or a
				jr z,skipblack

				ld b,c
				xor a
drawblack				
				ld (hl),a
				inc hl
				djnz drawblack
skipblack				
;----------------------------------------------		
copyhorizontal
				push de
				ld hl,#5980-1
				ld de,#5980-32
				ld b,16
copyh1				
				ld a,(hl)
				dec l
				ld (de),a
				inc e
				djnz copyh1
;----------------------------------------------						
copybottom				
				ld hl,#5800
				ld de,#5b00-1
				ld bc,384
copyb1				
				ld a,(hl)
				inc hl
				ld (de),a
				dec de
				dec c
				jr nz,copyb1
				dec b
				jr z,copyb1
				pop de
ending			
				jp cycle
fillpattern
				ld c,8
fillthird		
				ld a,(hl)
				ld b,0 ;256
fillline
				ld (de),a
				inc de
				djnz fillline
				inc hl
				dec c
				jr nz,fillthird
				ret
circle			
				db %11111111				
				db %11000011
				db %10000001
				db %10000001
				db %10000001
				db %10000001
				db %11000011
				db %11111111
circle1
				db %11111111
				db %11000111				
				db %10000011
				db %10000011
				db %10000011
				db %11000111
				db %11111111
				db %11111111				
counter			db 0
END
				DISPLAY END-START