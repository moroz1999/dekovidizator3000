			DEVICE 	ZXSPECTRUM128			
						
			EMPTYTRD "256.trd"
			
			org 	23867
			INCBIN 	"boot.bin"
			SAVETRD "256.trd","boot.B",23867,161
			
			INCLUDE "code.asm"
			SAVETRD "256.trd","code.C",#c000,256
			SAVESNA "compile.sna",#c000
		