 
















 
 
 
 












 

















; INT 41 - SYSTEM DATA - HARD DISK 0 PARAMETER TABLE ADDRESS [NOT A VECTOR!]
	times 0xe401 -($-$$) db 0x00

	 
	 
	 
	 
%rep 4
	dw       0  
	db       0  
	dw       0  
	dw  0xffff  
	db       0  
	db       0  
	db       0  
	db       0  
	db       0  
	dw  0xffff  
	db       0  
	db       0  
%endrep


; INT 15 C0 - SYSTEM - GET CONFIGURATION
; this is just a place to store the table; int 15 c0 returns a es:bx pointer to it.
	times 0xe6f5 -($-$$) db 0x00

	dw	9	 
	db	0xfc	 
	dw	0x401	 
	db	0x70	 

	dd	0

; INT 1E - SYSTEM DATA - DISKETTE PARAMETERS
; some data here was swiped from a running FreeDOS OS.
	times 0xefc7 -($-$$) db 0x00

	db      0xdf     
	                 
	db      0x02     
	                 
	db      0x25     
	db      0x02     
	db      0x24     
	db      0x1b     
	db      0xff     
	db      0x6c     
	db      0xf6     
	db      0x0f     
	db      0x08     
	db      0x4f     
	db      0x89     
	db      0x04     


; INT 1D - SYSTEM DATA - VIDEO PARAMETER TABLES
; some values swiped from a running FreeDOS OS.
	times 0xf0a4 -($-$$) db 0x00

	                 
	db 0x38, 0x28, 0x2d, 0x0a, 0x1f, 0x06, 0x19, 0x1c, 0x02, 0x07, 0x06, 0x07, 0x00, 0x00, 0x00, 0x00
	                 
	db 0x71, 0x50, 0x5a, 0x0a, 0x1f, 0x06, 0x19, 0x1c, 0x02, 0x07, 0x06, 0x07, 0x00, 0x00, 0x00, 0x00
	                 
	db 0x38, 0x28, 0x2d, 0x0a, 0x7f, 0x06, 0x64, 0x70, 0x02, 0x01, 0x06, 0x07, 0x00, 0x00, 0x00, 0x00
	                 
	db 0x61, 0x50, 0x52, 0x0f, 0x19, 0x06, 0x19, 0x19, 0x02, 0x0d, 0x0b, 0x0c, 0x00, 0x00, 0x00, 0x00
	dw       0x0800  
	dw       0x1000  
	dw       0x4000  
	dw       0x4000  
	                 
	db 0x28, 0x28, 0x50, 0x50, 0x28, 0x28, 0x50, 0x50
	                 
	db 0x2c, 0x28, 0x2d, 0x29, 0x2a, 0x2e, 0x1e, 0x29


; end
	times 0xfff6-($-$$) db 0x00
	db	'02/25/93',0   
	db	0xfc         
