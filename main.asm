move_cursor MACRO x,y
	            mov ah,2
	            mov bh,0
	            mov dl,x
	            mov dh,y
	            int 10h
ENDM
print_msg MACRO localmsg

	          mov ah,9
	          lea dx,localmsg
	          int 21h
ENDM



portinitialization MACRO  
  ;Set Divisor Latch Access Bit
	mov dx, 3fbh 			; Line Control Register
	mov al, 10000000b	;Set Divisor Latch Access Bit
	out dx, al				;Out it

  ;Set LSB byte of the Baud Rate Divisor Latch register.
	mov dx, 3f8h			
	mov al, 1		
	out dx, al

  ;Set MSB byte of the Baud Rate Divisor Latch register.
	mov dx, 3f9h
	mov al, 00h
	out dx, al

  ;Set port configuration
  mov dx,3fbh
	mov al,00011011b
                  ;0:Access to Receiver buffer, Transmitter buffer
                  ;0:Set Break disabled
                  ;011:Even Parity
                  ;0:One Stop Bit
                  ;11:8bits
	out dx,al
ENDM portinitialization
SEND MACRO
LOCAL AGAIN 
                       
mov dx , 3FDH ; Line Status Register
AGAIN: In al , dx ;Read Line Status
test al , 00100000b
JZ AGAIN ;Not empty (This line may need to change)
;If empty put the VALUE in Transmit data register
mov dx , 3F8H ; Transmit data register
mov al,VALUE
out dx , al
ENDM SEND 
RECEIVE MACRO
LOCAL CHK2
	;Check that Data is Ready
mov dx , 3FDH ; Line Status Register
CHK2: in al , dx
test al , 1
JZ CHK2 ;Not Ready (This line may need to change)
;If Ready read the VALUE in Receive data register
mov dx , 03F8H
in al , dx
mov VALUE , al
ENDM RECEIVE
RECEIVE1 MACRO
LOCAL CHK10
	;Check that Data is Ready
mov dx , 3FDH ; Line Status Register
in al , dx
test al , 1
JZ CHK10 ;Not Ready (This line may need to change)
;If Ready read the VALUE in Receive data register
mov dx , 03F8H
in al , dx
mov VALUE , al
CHK10: 
ENDM RECEIVE1
.MODEL HUGE
.STACK 128
.DATA

	SQUARE_SIZE             DW  31

	VALUE                   DB  ?

	; DATA ABOUT FIRST SNAKE
	ask_name                DB  "Please Enter your Name:",10,13,'$'
	name_s                  DB  19,?,19 dup('$')
	ask_name2               DB  "Please Enter second player Name:",10,13,'$'
	name_s2                 DB  15 dup('$')
	new_line                db  10,13
	pressenterkey           db  "Press Enter Key To Continue",10,13,'$'
	message                 db  "*To start Chatting Press F1",10,13,10,13, '*To Start Snake Rivals Press F2',10,13,10,13,'*To End the Program press ESC',10,13,10,13,'$'
	chat                    db  'now you start chatting$'

	determine_time          db  "How Long do You Want play Snake Rivals?", 10,13,10,13,13,'$'
	give_option             db  "Enter '1' IF Want One Minute,'3' IF Want Three Minutes Enter",10,13,10,13,'$'

	DETERMINE_LVL           DB  "Choose the level of the game",10,13,10,13,13,'$'
	give_option_FOR_LEVEL   db  "Enter '1' IF level 1,'2' IF level 2",10,13,10,13,'$'
	rec_game_inv_msg        db  "Do you  want to play?",'$'
	rec_chat_inv_msg        db  "Do you want  to chat?",'$'
	send_game_inv_msg       db  "Invitation is sent successfully, waitting for  Gamming....",'$'
	send_chat_inv_msg       db  "Invitation is sent successfully, Waitting for Chatting....",'$'
	



	; DATA ABOUT FIRST SNAKE
	SNAKE1_COLOR            EQU 2                                                                                                                                                                                                     	;GREEN
	SNAKE1_X                DW  15 DUP(500)                                                                                                                                                                                           	; INTITALLY
	SNAKE1_Y                DW  15 DUP(210)                                                                                                                                                                                           	; INTITALLY
	BGC                     EQU 200
	SNAKE1_HEADSHAPE_UP     DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, 106, 18, 215, 145, 23, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 236, 119, 119, 119, 119, 119, 119, 119
	                        DB  119, 119, 238, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 216, 119, 119, 119, 2, 2, 2, 2, 2, 119, 119, 119, 119, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 119, 2, 2, 2, 2, 2, 2, 2, 2, 2, 119, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, 215, 119, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 2, 2, 2, 2, 2
	                        DB  2, 2, 2, 119, 119, 2, 2, 2, 2, 119, 211, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 201, 119, 2, 2, 2, 119, 119, 2, 2, 2, 2, 119, 216, 190, 119, 2, 2
	                        DB  118, 4, 111, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 119, 2, 2, 119, 216, 216, 2, 2, 2, 2, 119, 216, 17, 119, 119, 2, 117, 40, 115, 119, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, 178, 119, 119, 119, 119, 119, 119, 191, 18, 119, 2, 2, 2, 2, 2, 119, 119, 119, 119, 119, 114, 40, 115, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 2, 119, 119, 119, 119
	                        DB  119, 119, 119, 2, 2, 2, 2, 2, 2, 2, 119, 117, 6, 40, 40, 115, 2, 119, 215, BGC, BGC, BGC, BGC, 119, 119, 2, 2, 2, 2, 2, 119, 2, 2, 2, 2, 2, 2, 2, 2, 2
	                        DB  2, 119, 115, 6, 40, 40, 115, 2, 119, 119, BGC, BGC, BGC, BGC, 119, 119, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 119, 115, 40, 118, 2, 119
	                        DB  119, BGC, BGC, BGC, BGC, 119, 2, 2, 2, 2, 2, 2, 2, 119, 119, 119, 2, 2, 2, 2, 118, 144, 119, 119, 2, 2, 115, 114, 119, 2, 119, 119, BGC, BGC, BGC, BGC, 119, 119, 2, 2
	                        DB  2, 2, 119, 143, 25, 26, 165, 119, 2, 2, 143, 28, 29, 27, 24, 144, 119, 118, 118, 2, 2, 119, 119, BGC, BGC, BGC, BGC, 119, 119, 2, 2, 2, 119, 166, 24, 21, 23, 29, 24, 119
	                        DB  119, 26, 29, 23, 21, 26, 29, 23, 119, 2, 2, 2, 119, 214, BGC, BGC, BGC, BGC, BGC, 119, 119, 119, 118, 25, 27, 18, 17, 16, 23, 29, 144, 144, 29, 23, 16, 16, 18, 28, 29, 118
	                        DB  119, 119, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 216, 119, 144, 30, 25, 17, 19, 17, 20, 28, 144, 143, 28, 20, 17, 224, 17, 26, 29, 144, 119, 215, 240, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, 216, 119, 144, 29, 26, 18, 17, 17, 21, 29, 144, 144, 29, 21, 18, 17, 18, 27, 29, 118, 119, 118, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 215, 119, 119, 28, 30, 22, 25
	                        DB  23, 26, 28, 119, 118, 29, 26, 23, 25, 23, 30, 28, 119, 119, 215, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 239, 119, 119, 24, 31, 30, 29, 29, 31, 25, 119, 119, 26, 31, 29, 29
	                        DB  30, 31, 24, 119, 119, 240, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 144, 28, 31, 31, 31, 30, 143, 119, 119, 168, 30, 31, 31, 31, 28, 144, 119, 119, 107, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 119, 143, 28, 30, 29, 23, 119, 119, 119, 119, 23, 29, 30, 28, 143, 119, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119
	                        DB  119, 119, 215, 143, 238, 191, 119, 2, 2, 119, 191, 238, 143, 216, 119, 119, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 202, 119, 2, 119, 119, 119, 119, 119, 2, 2, 2
	                        DB  2, 119, 119, 119, 119, 119, 2, 119, 240, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 2, 119, 119, 119, 2, 2, 2, 2, 2, 2, 119, 119, 2, 2, 119, 119, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 106, 119, 119, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 119, 119, 240, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, 239, 119, 119, 2, 2, 2, 119, 119, 119, 119, 119, 2, 119, 119, 119, 215, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 202, 119, 119, 119
	                        DB  119, 119, 215, 215, 119, 119, 119, 119, 119, 240, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 19, 240, 202, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC
						
	SNAKE1_HEADSHAPE_RIGHT  DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 119
	                        DB  119, 119, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 119, 2, 119, 119, 119, 178, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 239, 215, 216, 216, 119, 2, 2, 2, 2, 2, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, 202, 119, 119, 119, 119, 119, 119, 119, 119, 2, 2, 2, 2, 2, 2, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 106, 119, 119, 119, 119, 119, 119, 119, 144, 144
	                        DB  118, 2, 2, 2, 2, 2, 119, 119, 119, 201, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 239, 119, 119, 2, 119, 119, 144, 24, 28, 29, 30, 25, 119, 2, 2, 2, 2, 119, 119, 119
	                        DB  119, 119, 215, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 202, 119, 119, 2, 119, 119, 143, 28, 31, 30, 26, 25, 27, 166, 119, 2, 2, 2, 119, 119, 2, 2, 119, 119, 119, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, 119, 119, 2, 119, 119, 215, 28, 31, 30, 22, 18, 17, 18, 24, 143, 2, 2, 119, 119, 119, 2, 2, 2, 2, 119, 216, BGC, BGC, BGC, BGC, 19, 119, 2, 2, 119, 119, 143, 30, 31
	                        DB  29, 25, 17, 19, 17, 21, 25, 119, 2, 2, 119, 191, 119, 2, 2, 2, 119, 119, 236, BGC, BGC, BGC, 240, 119, 2, 2, 119, 119, 238, 29, 31, 29, 23, 17, 17, 16, 23, 26, 119, 2
	                        DB  2, 119, 18, 216, 119, 2, 2, 2, 119, 119, BGC, BGC, BGC, 202, 119, 2, 2, 2, 119, 191, 23, 30, 31, 26, 21, 20, 23, 29, 165, 119, 2, 2, 119, 119, 216, 119, 2, 2, 2, 119
	                        DB  119, BGC, BGC, BGC, BGC, 119, 119, 2, 2, 2, 119, 119, 143, 25, 28, 29, 28, 29, 24, 119, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 119, 106, BGC, BGC, BGC, 215, 119, 2, 2
	                        DB  2, 2, 119, 119, 119, 119, 144, 144, 144, 119, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 119, 18, BGC, BGC, BGC, 215, 119, 2, 2, 2, 2, 119, 119, 119, 118, 144, 143, 144
	                        DB  119, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 119, 215, BGC, BGC, BGC, 119, 119, 2, 2, 2, 119, 119, 168, 26, 29, 29, 28, 29, 26, 143, 2, 2, 2, 2, 2, 2, 2
	                        DB  2, 2, 2, 2, 119, 145, BGC, BGC, BGC, 119, 119, 2, 2, 119, 191, 23, 30, 31, 26, 21, 20, 23, 29, 28, 118, 2, 2, 2, 2, 119, 119, 119, 2, 2, 2, 119, 23, BGC, BGC, BGC
	                        DB  119, 2, 2, 119, 119, 238, 29, 31, 29, 23, 18, 17, 16, 23, 29, 144, 2, 2, 2, 119, 216, 216, 119, 2, 2, 119, 119, BGC, BGC, BGC, BGC, 119, 119, 2, 119, 119, 143, 30, 31, 29
	                        DB  25, 17, 224, 16, 21, 27, 119, 2, 2, 2, 119, 17, 190, 2, 2, 2, 119, 119, BGC, BGC, BGC, BGC, 119, 119, 2, 2, 119, 216, 28, 31, 30, 23, 18, 17, 18, 26, 24, 119, 2, 119
	                        DB  119, 119, 119, 119, 2, 2, 119, 119, 238, BGC, BGC, BGC, BGC, 240, 119, 119, 2, 119, 119, 143, 28, 31, 30, 27, 26, 28, 29, 144, 2, 2, 115, 117, 119, 119, 2, 2, 2, 119, 119, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, 215, 119, 119, 2, 119, 119, 144, 24, 28, 29, 29, 29, 23, 119, 2, 119, 6, 6, 119, 2, 2, 2, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 240, 119, 119
	                        DB  119, 119, 119, 119, 119, 118, 144, 118, 119, 118, 115, 115, 40, 40, 114, 117, 118, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 240, 119, 119, 119, 119, 119, 119, 119, 119, 2
	                        DB  118, 114, 40, 40, 40, 40, 40, 4, 211, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 107, 240, 215, 118, 215, 119, 2, 2, 119, 118, 115, 115, 115, 115, 111, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 240, 119, 2, 2, 2, 2, 2, 2, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 119, 119, 119, 119, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, 214, 119, 119, 119, 119, 215, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC

	SNAKE1_HEADSHAPE_LEFT   DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 215, 119, 119, 119, 119, 214, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 119, 119, 119, 119, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 2, 2, 2, 2, 2, 2, 119, 240, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, 111, 115, 115, 115, 115, 118, 119, 2, 2, 119, 215, 118, 215, 240, 107, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 211, 4, 40, 40, 40, 40, 40, 114
	                        DB  118, 2, 119, 119, 119, 119, 119, 119, 119, 119, 240, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 118, 117, 114, 40, 40, 115, 115, 118, 119, 118, 144, 118, 119, 119, 119, 119
	                        DB  119, 119, 119, 240, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 2, 2, 2, 119, 6, 6, 119, 2, 119, 23, 29, 29, 29, 28, 24, 144, 119, 119, 2, 119, 119, 215, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, 119, 119, 2, 2, 2, 119, 119, 117, 115, 2, 2, 144, 29, 28, 26, 27, 30, 31, 28, 143, 119, 119, 2, 119, 119, 240, BGC, BGC, BGC, BGC, 238, 119, 119, 2, 2, 119, 119, 119
	                        DB  119, 119, 2, 119, 24, 26, 18, 17, 18, 23, 30, 31, 28, 216, 119, 2, 2, 119, 119, BGC, BGC, BGC, BGC, 119, 119, 2, 2, 2, 190, 17, 119, 2, 2, 2, 119, 27, 21, 16, 224, 17
	                        DB  25, 29, 31, 30, 143, 119, 119, 2, 119, 119, BGC, BGC, BGC, BGC, 119, 119, 2, 2, 119, 216, 216, 119, 2, 2, 2, 144, 29, 23, 16, 17, 18, 23, 29, 31, 29, 238, 119, 119, 2, 2
	                        DB  119, BGC, BGC, BGC, 23, 119, 2, 2, 2, 119, 119, 119, 2, 2, 2, 2, 118, 28, 29, 23, 20, 21, 26, 31, 30, 23, 191, 119, 2, 2, 119, 119, BGC, BGC, BGC, 145, 119, 2, 2, 2
	                        DB  2, 2, 2, 2, 2, 2, 2, 2, 143, 26, 29, 28, 29, 29, 26, 168, 119, 119, 2, 2, 2, 119, 119, BGC, BGC, BGC, 215, 119, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
	                        DB  119, 144, 143, 144, 118, 119, 119, 119, 2, 2, 2, 2, 119, 215, BGC, BGC, BGC, 18, 119, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 119, 144, 144, 144, 119, 119, 119, 119, 2
	                        DB  2, 2, 2, 119, 215, BGC, BGC, BGC, 106, 119, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 119, 24, 29, 28, 29, 28, 25, 143, 119, 119, 2, 2, 2, 119, 119, BGC, BGC, BGC, BGC
	                        DB  119, 119, 2, 2, 2, 119, 216, 119, 119, 2, 2, 119, 165, 29, 23, 20, 21, 26, 31, 30, 23, 191, 119, 2, 2, 2, 119, 202, BGC, BGC, BGC, 119, 119, 2, 2, 2, 119, 216, 18, 119
	                        DB  2, 2, 119, 26, 23, 16, 17, 17, 23, 29, 31, 29, 238, 119, 119, 2, 2, 119, 240, BGC, BGC, BGC, 236, 119, 119, 2, 2, 2, 119, 191, 119, 2, 2, 119, 25, 21, 17, 19, 17, 25
	                        DB  29, 31, 30, 143, 119, 119, 2, 2, 119, 19, BGC, BGC, BGC, BGC, 216, 119, 2, 2, 2, 2, 119, 119, 119, 2, 2, 143, 24, 18, 17, 18, 22, 30, 31, 28, 215, 119, 119, 2, 119, 119
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 119, 2, 2, 119, 119, 2, 2, 2, 119, 166, 27, 25, 26, 30, 31, 28, 143, 119, 119, 2, 119, 119, 202, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 215, 119
	                        DB  119, 119, 119, 119, 2, 2, 2, 2, 119, 25, 30, 29, 28, 24, 144, 119, 119, 2, 119, 119, 239, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 201, 119, 119, 119, 2, 2, 2, 2, 2
	                        DB  118, 144, 144, 119, 119, 119, 119, 119, 119, 119, 106, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 2, 2, 2, 2, 2, 2, 119, 119, 119, 119, 119, 119, 119, 119, 202
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 2, 2, 2, 2, 2, 119, 216, 216, 215, 239, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, 178, 119, 119, 119, 2, 119, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119
	                        DB  119, 119, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC

	SNAKE1_HEADSHAPE_DOWN   DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 202, 240, 19, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 240, 119, 119, 119, 119, 119, 215, 215, 119
	                        DB  119, 119, 119, 119, 202, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 215, 119, 119, 119, 2, 119, 119, 119, 119, 119, 2, 2, 2, 119, 119, 239, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 240, 119, 119, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 119, 119, 106, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, 119, 119, 2, 2, 119, 119, 2, 2, 2, 2, 2, 2, 119, 119, 119, 2, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 240, 119, 2, 119, 119, 119, 119, 119
	                        DB  2, 2, 2, 2, 119, 119, 119, 119, 119, 2, 119, 202, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 119, 119, 216, 143, 238, 191, 119, 2, 2, 119, 191, 238, 143, 215, 119
	                        DB  119, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 119, 143, 28, 30, 29, 23, 119, 119, 119, 119, 23, 29, 30, 28, 143, 119, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, 107, 119, 119, 144, 28, 31, 31, 31, 30, 168, 119, 119, 143, 30, 31, 31, 31, 28, 144, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 240, 119, 119, 24, 31
	                        DB  30, 29, 29, 31, 26, 119, 119, 25, 31, 29, 29, 30, 31, 24, 119, 119, 239, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 215, 119, 119, 28, 30, 23, 25, 23, 26, 29, 118, 119, 28, 26
	                        DB  23, 25, 22, 30, 28, 119, 119, 215, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 118, 119, 118, 29, 27, 18, 17, 18, 21, 29, 144, 144, 29, 21, 17, 17, 18, 26, 29, 144, 119, 216, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, 240, 215, 119, 144, 29, 26, 17, 224, 17, 20, 28, 143, 144, 28, 20, 17, 19, 17, 25, 30, 144, 119, 216, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 119
	                        DB  119, 118, 29, 28, 18, 16, 16, 23, 29, 144, 144, 29, 23, 16, 17, 18, 27, 25, 118, 119, 119, 119, BGC, BGC, BGC, BGC, BGC, 214, 119, 2, 2, 2, 119, 23, 29, 26, 21, 23, 29, 26
	                        DB  119, 119, 24, 29, 23, 21, 24, 166, 119, 2, 2, 2, 119, 119, BGC, BGC, BGC, BGC, 119, 119, 2, 2, 118, 118, 119, 144, 24, 27, 29, 28, 143, 2, 2, 119, 165, 26, 25, 143, 119, 2
	                        DB  2, 2, 2, 119, 119, BGC, BGC, BGC, BGC, 119, 119, 2, 119, 114, 115, 2, 2, 119, 119, 144, 118, 2, 2, 2, 2, 119, 119, 119, 2, 2, 2, 2, 2, 2, 2, 119, BGC, BGC, BGC, BGC
	                        DB  119, 119, 2, 118, 40, 115, 119, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 119, 119, BGC, BGC, BGC, BGC, 119, 119, 2, 115, 40, 40, 6, 115, 119
	                        DB  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 119, 2, 2, 2, 2, 2, 119, 119, BGC, BGC, BGC, BGC, 215, 119, 2, 115, 40, 40, 6, 117, 119, 2, 2, 2, 2, 2, 2, 2, 119, 119
	                        DB  119, 119, 119, 119, 119, 2, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 115, 40, 114, 119, 119, 119, 119, 119, 2, 2, 2, 2, 2, 119, 18, 191, 119, 119, 119, 119, 119, 119, 178, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, 119, 115, 40, 117, 2, 119, 119, 17, 216, 119, 2, 2, 2, 2, 216, 216, 119, 2, 2, 119, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 111, 4
	                        DB  118, 2, 2, 119, 190, 216, 119, 2, 2, 2, 2, 119, 119, 2, 2, 2, 119, 201, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 211, 119, 2, 2, 2, 2, 119, 119, 2, 2
	                        DB  2, 2, 2, 2, 2, 2, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 119, 215, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 119, 2, 2, 2, 2, 2, 2, 2, 2, 2, 119, 119, 119, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, 119, 119, 119, 119, 2, 2, 2, 2, 2, 119, 119, 119, 216, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 238, 119
	                        DB  119, 119, 119, 119, 119, 119, 119, 119, 236, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 23, 145, 215, 18, 106, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC
	; INTITALLY
	

	; DATA ABOUT SECOND SNAKE
	
	SNAKE2_COLOR            EQU 6                                                                                                                                                                                                     	; BROWN
	SNAKE2_X                DW  15 DUP(160)                                                                                                                                                                                           	; INTITALLY
	SNAKE2_Y                DW  15 DUP(210)

	

	                    
	SNAKE2_HEADSHAPE_UP     DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 27, 58, 58, 58, 28, 29, 28, 26
	                        DB  5, 5, 26, 28, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 28, 25, 5, 35, 35, 35, 5, 35, 5, 35, 35, 35, 35, 5, 27, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 25, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 5, 27, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, 26, 35, 35, 5, 5, 5, 35, 35, 35, 35, 35, 35, 5, 5, 35, 35, 5, 28, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 5, 35, 5, 237, 216, 239, 132
	                        DB  35, 35, 35, 5, 130, 215, 215, 21, 5, 35, 26, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 27, 35, 5, 239, 144, 166, 143, 215, 5, 35, 35, 131, 216, 168, 167, 214, 20
	                        DB  35, 5, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 26, 35, 130, 23, 29, BGC, 29, 22, 130, 35, 5, 237, 25, BGC, BGC, 28, 168, 132, 5, 27, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, 29, 5, 5, 22, BGC, BGC, BGC, BGC, 29, 21, 5, 5, 23, BGC, BGC, BGC, BGC, 28, 21, 5, 27, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 5, 132, 27, BGC
	                        DB  29, 28, 28, BGC, 24, 5, 132, 27, BGC, 28, 28, 29, BGC, 24, 5, 26, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 28, 35, 156, 29, 28, 21, 25, 22, 27, 27, 5, 156, 29, 24
	                        DB  23, 24, 22, BGC, 27, 5, 26, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 28, 35, 25, BGC, 24, 17, 17, 18, 23, 28, 5, 25, 28, 20, 17, 17, 18, 27, 28, 5, 5, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 26, 5, 25, BGC, 23, 17, 19, 17, 22, 28, 5, 25, 28, 19, 17, 19, 17, 27, 29, 5, 25, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 27, 5, 5
	                        DB  5, 25, BGC, 27, 18, 16, 17, 25, 28, 5, 156, 29, 22, 17, 16, 237, 28, 26, 5, 5, 26, 28, BGC, BGC, BGC, BGC, BGC, 29, 5, 35, 35, 35, 5, 26, 29, 26, 22, 25, BGC, 26
	                        DB  5, 5, 26, 28, 24, 23, 25, 5, 35, 35, 35, 35, 5, 29, BGC, BGC, BGC, BGC, 27, 35, 35, 35, 5, 35, 35, 5, 26, 28, 29, 27, 5, 35, 35, 5, 26, 27, 26, 5, 35, 35
	                        DB  35, 35, 35, 5, 27, BGC, BGC, BGC, BGC, 26, 35, 35, 5, 109, 5, 35, 35, 35, 5, 5, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 27, BGC, BGC, BGC, BGC
	                        DB  26, 35, 35, 5, 4, 5, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 5, 28, BGC, BGC, BGC, BGC, 27, 35, 35, 109, 40, 40, 109, 5, 35
	                        DB  35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 5, 29, BGC, BGC, BGC, BGC, 29, 5, 35, 39, 40, 40, 5, 5, 35, 35, 35, 35, 35, 35, 35, 35, 5, 132
	                        DB  5, 35, 35, 35, 35, 35, 5, 28, BGC, BGC, BGC, BGC, BGC, BGC, 28, 5, 109, 40, 5, 35, 5, 5, 131, 5, 35, 35, 35, 35, 35, 131, 18, 131, 35, 35, 5, 5, 25, 28, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, 29, 23, 4, 5, 35, 35, 131, 17, 131, 35, 35, 35, 35, 35, 204, 227, 5, 35, 35, 5, 26, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 156
	                        DB  5, 35, 35, 5, 204, 130, 35, 35, 35, 35, 35, 5, 35, 35, 35, 35, 27, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 28, 5, 35, 35, 35, 35, 35, 35, 35, 35
	                        DB  35, 35, 35, 35, 35, 35, 5, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 27, 5, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 27, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 28, 5, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 5, 26, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, 29, 26, 5, 35, 35, 35, 35, 35, 35, 5, 5, 27, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29
	                        DB  28, 58, 58, 26, 26, 27, 28, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC

	SNAKE2_HEADSHAPE_RIGHT  DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 27, 27
	                        DB  28, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 28, 5, 5, 35, 5, 5, 28, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 26, 35, 35, 35, 35, 35, 5, 28, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, 29, 27, 27, 26, 26, 5, 25, 5, 35, 35, 35, 35, 35, 35, 25, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 28, 26, 5, 5, 5, 5, 5, 5, 5
	                        DB  5, 35, 35, 35, 35, 35, 35, 5, 26, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 27, 5, 35, 35, 132, 21, 24, 27, 28, 29, 26, 35, 35, 35, 35, 35, 35, 5, 5
	                        DB  27, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 27, 5, 35, 5, 20, 168, 28, BGC, BGC, 27, 27, 28, 5, 35, 35, 35, 35, 35, 35, 35, 35, 5, 27, 29, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, 28, 5, 35, 35, 21, 214, 28, BGC, 29, 22, 18, 17, 237, 25, 5, 35, 35, 35, 35, 35, 35, 35, 35, 35, 26, BGC, BGC, BGC, BGC, BGC, BGC, 26, 35, 35, 5, 215, 167, BGC, BGC
	                        DB  28, 24, 17, 19, 16, 23, 26, 35, 35, 35, 5, 131, 5, 35, 35, 35, 5, 27, BGC, BGC, BGC, BGC, 29, 5, 35, 35, 5, 215, 168, BGC, BGC, 28, 23, 17, 17, 17, 24, 27, 35, 35
	                        DB  35, 132, 18, 227, 35, 35, 35, 35, 5, BGC, BGC, BGC, BGC, 29, 5, 35, 35, 35, 130, 216, 25, BGC, BGC, 24, 20, 19, 22, 28, 26, 35, 35, 35, 5, 131, 204, 5, 35, 35, 35, 5
	                        DB  28, BGC, BGC, BGC, BGC, 26, 35, 35, 35, 5, 131, 237, 23, 27, 29, 28, 28, 29, 26, 5, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 27, BGC, BGC, BGC, BGC, 28, 5, 35, 35
	                        DB  35, 35, 5, 5, 132, 156, 25, 25, 156, 5, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 26, BGC, BGC, BGC, BGC, 29, 35, 35, 35, 35, 35, 35, 5, 5, 5, 5, 5, 5
	                        DB  5, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 26, BGC, BGC, BGC, BGC, 28, 5, 35, 35, 35, 5, 130, 21, 24, 27, 28, 28, 28, 26, 5, 35, 35, 35, 35, 35, 35, 35
	                        DB  35, 35, 35, 35, 58, BGC, BGC, BGC, BGC, 58, 35, 35, 35, 132, 215, 22, 29, BGC, 27, 23, 22, 25, BGC, 27, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 58, BGC, BGC, BGC, BGC
	                        DB  58, 35, 35, 5, 239, 143, 29, BGC, 28, 22, 18, 17, 17, 25, 29, 5, 35, 35, 35, 5, 131, 130, 35, 35, 35, 35, 28, BGC, BGC, BGC, BGC, 58, 35, 35, 5, 216, 166, BGC, BGC, 28
	                        DB  25, 17, 19, 16, 22, 28, 5, 35, 35, 35, 131, 17, 204, 35, 35, 35, 5, 29, BGC, BGC, BGC, BGC, 27, 5, 35, 5, 237, 144, 29, BGC, 29, 21, 17, 17, 18, 26, 26, 35, 35, 35
	                        DB  35, 5, 131, 5, 35, 35, 35, 26, BGC, BGC, BGC, BGC, BGC, 29, 25, 35, 35, 5, 239, 23, BGC, BGC, 28, 24, 23, 27, 29, 5, 35, 35, 5, 5, 5, 35, 35, 35, 35, 5, 29, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, 28, 25, 35, 35, 5, 130, 22, 27, 29, BGC, BGC, BGC, 26, 35, 35, 35, 109, 5, 35, 35, 35, 35, 5, 28, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 26, 5
	                        DB  35, 35, 5, 132, 156, 25, 25, 25, 5, 35, 5, 5, 40, 40, 5, 5, 5, 5, 27, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 27, 26, 5, 5, 35, 35, 5, 5, 35
	                        DB  5, 109, 4, 40, 40, 40, 4, 156, 28, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 29, 28, 28, 26, 5, 35, 35, 5, 5, 109, 39, 109, 23, 29, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 5, 35, 35, 35, 35, 35, 35, 5, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 27, 5, 35, 35, 35, 35, 5, 28, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, 29, 27, 26, 26, 27, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC




	SNAKE2_HEADSHAPE_LEFT   DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 27, 26, 26, 27, 29, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 28, 5, 35, 35, 35, 35, 5, 27, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 5, 35, 35, 35, 35, 35, 35, 5, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, 29, 23, 109, 39, 109, 5, 5, 35, 35, 5, 26, 28, 28, 29, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 28, 156, 4, 40, 40, 40, 4, 109
	                        DB  5, 35, 5, 5, 35, 35, 5, 5, 26, 27, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 27, 5, 5, 5, 5, 40, 40, 5, 5, 35, 5, 25, 25, 25, 156, 132, 5, 35
	                        DB  35, 5, 26, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 28, 5, 35, 35, 35, 35, 5, 109, 35, 35, 35, 26, BGC, BGC, BGC, 29, 27, 22, 130, 5, 35, 35, 25, 28, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, 29, 5, 35, 35, 35, 35, 5, 5, 5, 35, 35, 5, 29, 27, 23, 24, 28, BGC, BGC, 23, 239, 5, 35, 35, 25, 29, BGC, BGC, BGC, BGC, BGC, 26, 35, 35, 35, 5, 131, 5
	                        DB  35, 35, 35, 35, 26, 26, 18, 17, 17, 21, 29, BGC, 29, 144, 237, 5, 35, 5, 27, BGC, BGC, BGC, BGC, 29, 5, 35, 35, 35, 204, 17, 131, 35, 35, 35, 5, 28, 22, 16, 19, 17
	                        DB  25, 28, BGC, BGC, 166, 216, 5, 35, 35, 58, BGC, BGC, BGC, BGC, 28, 35, 35, 35, 35, 130, 131, 5, 35, 35, 35, 5, 29, 25, 17, 17, 18, 22, 28, BGC, 29, 143, 239, 5, 35, 35
	                        DB  58, BGC, BGC, BGC, BGC, 58, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 27, BGC, 25, 22, 23, 27, BGC, 29, 22, 215, 132, 35, 35, 35, 58, BGC, BGC, BGC, BGC, 58, 35, 35, 35
	                        DB  35, 35, 35, 35, 35, 35, 35, 35, 5, 26, 28, 28, 28, 27, 24, 21, 130, 5, 35, 35, 35, 5, 28, BGC, BGC, BGC, BGC, 26, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35
	                        DB  5, 5, 5, 5, 5, 5, 5, 35, 35, 35, 35, 35, 35, 29, BGC, BGC, BGC, BGC, 26, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 5, 156, 25, 25, 156, 132, 5, 5, 35
	                        DB  35, 35, 35, 5, 28, BGC, BGC, BGC, BGC, 27, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 5, 26, 29, 28, 28, 29, 27, 23, 237, 131, 5, 35, 35, 35, 26, BGC, BGC, BGC, BGC
	                        DB  28, 5, 35, 35, 35, 5, 204, 131, 5, 35, 35, 35, 26, 28, 22, 19, 20, 24, BGC, BGC, 25, 216, 130, 35, 35, 35, 5, 29, BGC, BGC, BGC, BGC, 5, 35, 35, 35, 35, 227, 18, 132
	                        DB  35, 35, 35, 27, 24, 17, 17, 17, 23, 28, BGC, BGC, 168, 215, 5, 35, 35, 5, 29, BGC, BGC, BGC, BGC, 27, 5, 35, 35, 35, 5, 131, 5, 35, 35, 35, 26, 23, 16, 19, 17, 24
	                        DB  28, BGC, BGC, 167, 215, 5, 35, 35, 26, BGC, BGC, BGC, BGC, BGC, BGC, 26, 35, 35, 35, 35, 35, 35, 35, 35, 35, 5, 25, 237, 17, 18, 22, 29, BGC, 28, 214, 21, 35, 35, 5, 28
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, 29, 27, 5, 35, 35, 35, 35, 35, 35, 35, 35, 5, 28, 27, 27, BGC, BGC, 28, 168, 20, 5, 35, 5, 27, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29
	                        DB  27, 5, 5, 35, 35, 35, 35, 35, 35, 26, 29, 28, 27, 24, 21, 132, 35, 35, 5, 27, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 26, 5, 35, 35, 35, 35, 35, 35
	                        DB  5, 5, 5, 5, 5, 5, 5, 5, 26, 28, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 25, 35, 35, 35, 35, 35, 35, 5, 25, 5, 26, 26, 27, 27, 29, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 28, 5, 35, 35, 35, 35, 35, 26, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, 28, 5, 5, 35, 5, 5, 28, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29
	                        DB  28, 27, 27, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC


	SNAKE2_HEADSHAPE_DOWN   DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 27, 58, 58, 58, 28, 29, 28, 26
	                        DB  5, 5, 26, 28, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 28, 25, 5, 35, 35, 35, 5, 35, 5, 35, 35, 35, 35, 5, 27, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 25, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 5, 27, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, 26, 35, 35, 5, 5, 5, 35, 35, 35, 35, 35, 35, 5, 5, 35, 35, 5, 28, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 5, 35, 5, 237, 216, 239, 132
	                        DB  35, 35, 35, 5, 130, 215, 215, 21, 5, 35, 26, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 27, 35, 5, 239, 144, 166, 143, 215, 5, 35, 35, 131, 216, 168, 167, 214, 20
	                        DB  35, 5, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 26, 35, 130, 23, 29, BGC, 29, 22, 130, 35, 5, 237, 25, BGC, BGC, 28, 168, 132, 5, 27, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, 29, 5, 5, 22, BGC, BGC, BGC, BGC, 29, 21, 5, 5, 23, BGC, BGC, BGC, BGC, 28, 21, 5, 27, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 5, 132, 27, BGC
	                        DB  29, 28, 28, BGC, 24, 5, 132, 27, BGC, 28, 28, 29, BGC, 24, 5, 26, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 28, 35, 156, 29, 28, 21, 25, 22, 27, 27, 5, 156, 29, 24
	                        DB  23, 24, 22, BGC, 27, 5, 26, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 28, 35, 25, BGC, 24, 17, 17, 18, 23, 28, 5, 25, 28, 20, 17, 17, 18, 27, 28, 5, 5, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 26, 5, 25, BGC, 23, 17, 19, 17, 22, 28, 5, 25, 28, 19, 17, 19, 17, 27, 29, 5, 25, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 27, 5, 5
	                        DB  5, 25, BGC, 27, 18, 16, 17, 25, 28, 5, 156, 29, 22, 17, 16, 237, 28, 26, 5, 5, 26, 28, BGC, BGC, BGC, BGC, BGC, 29, 5, 35, 35, 35, 5, 26, 29, 26, 22, 25, BGC, 26
	                        DB  5, 5, 26, 28, 24, 23, 25, 5, 35, 35, 35, 35, 5, 29, BGC, BGC, BGC, BGC, 27, 35, 35, 35, 5, 35, 35, 5, 26, 28, 29, 27, 5, 35, 35, 5, 26, 27, 26, 5, 35, 35
	                        DB  35, 35, 35, 5, 27, BGC, BGC, BGC, BGC, 26, 35, 35, 5, 109, 5, 35, 35, 35, 5, 5, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 27, BGC, BGC, BGC, BGC
	                        DB  26, 35, 35, 5, 4, 5, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 5, 28, BGC, BGC, BGC, BGC, 27, 35, 35, 109, 40, 40, 109, 5, 35
	                        DB  35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 5, 29, BGC, BGC, BGC, BGC, 29, 5, 35, 39, 40, 40, 5, 5, 35, 35, 35, 35, 35, 35, 35, 35, 5, 132
	                        DB  5, 35, 35, 35, 35, 35, 5, 28, BGC, BGC, BGC, BGC, BGC, BGC, 28, 5, 109, 40, 5, 35, 5, 5, 131, 5, 35, 35, 35, 35, 35, 131, 18, 131, 35, 35, 5, 5, 25, 28, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, 29, 23, 4, 5, 35, 35, 131, 17, 131, 35, 35, 35, 35, 35, 204, 227, 5, 35, 35, 5, 26, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 156
	                        DB  5, 35, 35, 5, 204, 130, 35, 35, 35, 35, 35, 5, 35, 35, 35, 35, 27, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 28, 5, 35, 35, 35, 35, 35, 35, 35, 35
	                        DB  35, 35, 35, 35, 35, 35, 5, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 27, 5, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 27, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 28, 5, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 5, 26, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, 29, 26, 5, 35, 35, 35, 35, 35, 35, 5, 5, 27, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29
	                        DB  28, 58, 58, 26, 26, 27, 28, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC

	APPLE                   DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 104, 46, 46, 46, 46, 46, 46, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, 244, BGC, 104, 46, 46, 46, 46, 46, 46, 46, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 244, 137, 137, 136, 140, 46
	                        DB  46, 46, 46, 46, 46, 46, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 244, 137, 137, 136, 46, 46, 46, 46, 46, 46, 46, 116, 178, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 244, 137, 136, 46, 46, 46, 46, 46, 46, 46, 1, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, 20, 20, BGC, BGC, BGC, 137, 136, 46, 46, 46, 46, 46, 46, 140, 227, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 20, BGC, 136, 136, 136, 136, BGC, BGC
	                        DB  136, 137, 46, 46, 46, 46, 6, 136, 136, BGC, 20, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 244, BGC, 41, 39, 41, 41, 41, 41, 39, 39, 136, 138, 116, 41, 41, 39, 39, 39, 41
	                        DB  39, 41, BGC, 244, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 20, 136, 39, 39, 39, 39, 39, 39, 39, 39, 39, 41, 6, 41, 39, 39, 39, 39, 39, 39, 39, 39, 39, 136, 20, BGC, BGC, BGC, BGC
	                        DB  BGC, 244, 136, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 136, 244, BGC, BGC, BGC, BGC, 124, 39, 39, 39, 39, 39, 39, 39
	                        DB  39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 41, 41, 39, 39, 39, 39, 124, BGC, BGC, BGC, 196, 41, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39
	                        DB  39, 39, 12, 64, 64, 12, 39, 39, 39, 41, 196, BGC, BGC, BGC, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 41, 64, 65, 65, 64, 41, 39, 39
	                        DB  39, BGC, BGC, BGC, 124, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 41, 12, 65, 65, 64, 12, 39, 39, 39, 124, BGC, BGC, BGC, 41, 39, 39, 39
	                        DB  39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 12, 64, 65, 64, 41, 39, 39, 41, BGC, BGC, 244, 136, 41, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39
	                        DB  39, 39, 39, 39, 39, 39, 41, 12, 12, 12, 39, 39, 39, 41, 136, 244, 244, 136, 41, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39
	                        DB  39, 39, 39, 39, 41, 136, 244, BGC, BGC, 41, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 41, BGC, BGC, BGC, 124
	                        DB  39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 124, BGC, BGC, BGC, 39, 39, 39, 39, 39, 39, 39, 39, 39
	                        DB  39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, BGC, BGC, BGC, 3, 41, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39
	                        DB  39, 39, 39, 39, 39, 39, 39, 39, 41, 3, BGC, BGC, 196, 41, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 41
	                        DB  196, BGC, BGC, BGC, 123, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 123, BGC, BGC, BGC, BGC, 124, 41, 39, 39, 39
	                        DB  39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 41, 124, BGC, BGC, BGC, BGC, 244, 136, 41, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39
	                        DB  39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 41, 136, 244, BGC, BGC, BGC, BGC, BGC, 123, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39
	                        DB  39, 39, 123, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 123, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 123, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, 244, 136, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 136, 244, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 196, 41, 39, 39, 39, 39, 39
	                        DB  39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 41, 196, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 196, 41, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39
	                        DB  39, 39, 41, 196, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 20, 136, 39, 39, 39, 39, 39, 41, 39, 41, 39, 39, 39, 39, 39, 136, 20, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC




	GOLDEN_APPLE            DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 12, 65, 66, 66, 66, 66, 66, 66, 65, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, 138, 139, 139, 140, 139, 139, 138, 212, 140, 65, 65, 66, 66, 66, 66, 66, 66, 65, 42, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 137, 138, 138, 139, 139, 140, 140, 140, 140, 139, 139
	                        DB  65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 42, 114, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 212, 212, 138, 140, 164, 65, 65, 65, 65, 65, 65, 65, 65, 65, 140, 139, 138, 138, 139, 6, 6
	                        DB  6, 137, 210, BGC, BGC, BGC, BGC, BGC, BGC, 137, 212, 212, 138, 140, 66, 66, 66, 66, 66, 65, 42, 42, 42, 42, 6, 139, 138, 137, 139, 140, 164, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 137
	                        DB  212, 212, 212, 138, 139, 140, 140, 65, 66, 65, 42, 6, 6, 6, 140, 6, 137, 211, 211, 138, 140, 140, 25, BGC, BGC, BGC, BGC, BGC, BGC, 138, 212, 211, 210, 211, 212, 138, 139, 6, 140, 140
	                        DB  138, 42, 6, 212, 137, 211, 210, 210, 211, 137, 138, 140, 140, 25, 65, BGC, BGC, BGC, BGC, BGC, 137, 211, 210, 209, 210, 137, 139, 139, 139, 139, 6, 6, 42, 6, 115, 137, 138, 6, 140, 140
	                        DB  140, 140, 140, 140, 164, 65, BGC, BGC, BGC, BGC, 138, 211, 210, 210, 137, 6, 42, 65, 65, 65, 65, 140, 140, 140, 140, 140, 140, 65, 66, 66, 66, 66, 67, 67, 66, 25, 65, 66, BGC, BGC
	                        DB  BGC, 137, 210, 211, 6, 42, 65, 65, 65, 65, 66, 66, 66, 66, 66, 65, 66, 66, 66, 67, 67, 67, 67, 67, 67, 67, 66, 65, 66, BGC, BGC, 139, 114, 210, 6, 42, 42, 65, 65, 65
	                        DB  65, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 67, 67, 67, 67, 66, 66, BGC, BGC, 138, 114, 211, 42, 42, 42, 42, 65, 65, 65, 65, 65, 65, 66, 66, 66, 66, 66
	                        DB  66, 66, 66, 66, 66, 66, 67, 67, 67, 67, 66, 65, BGC, 138, 137, 138, 42, 42, 42, 42, 12, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 66, 66, 66, 66, 66, 67, 67
	                        DB  67, 66, 65, BGC, 138, 137, 6, 42, 42, 42, 42, 42, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 66, 66, 66, 66, 67, 67, 67, 66, 65, BGC, 138, 138, 140, 42, 42
	                        DB  42, 42, 42, 12, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 66, 66, 66, 66, 67, 67, 66, 65, BGC, 138, 6, 140, 42, 42, 42, 42, 42, 12, 12, 12, 12, 12, 12
	                        DB  12, 12, 65, 65, 65, 65, 65, 65, 65, 66, 66, 66, 66, 67, 66, 65, BGC, 138, 6, 140, 42, 42, 42, 42, 42, 42, 12, 12, 12, 12, 12, 12, 12, 65, 65, 65, 65, 65, 65, 65
	                        DB  65, 66, 66, 66, 67, 66, 65, BGC, 137, 6, 6, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 12, 65, 65, 65, 65, 65, 65, 65, 66, 66, 66, 66, 139, BGC, 210
	                        DB  6, 6, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 12, 12, 65, 65, 65, 65, 66, 66, 66, 65, BGC, BGC, BGC, 6, 6, 42, 42, 42, 42, 42, 42, 42
	                        DB  42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 12, 65, 65, 65, 66, 66, 66, 65, BGC, BGC, BGC, 137, 6, 140, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42
	                        DB  42, 42, 42, 12, 65, 65, 65, 66, 65, 140, BGC, BGC, BGC, 186, 6, 6, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 65, 65, 65, 66, 65
	                        DB  BGC, BGC, BGC, BGC, BGC, 138, 6, 140, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 65, 65, 65, 65, 140, BGC, BGC, BGC, BGC, BGC, 114, 6, 6, 42
	                        DB  42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 65, 65, 65, 42, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 138, 6, 140, 42, 42, 42, 42, 42, 42, 42, 42, 42
	                        DB  42, 42, 42, 42, 42, 42, 42, 42, 65, 65, 12, 138, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 209, 6, 6, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 65
	                        DB  42, 140, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 137, 6, 140, 42, 42, 140, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 140, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, 6, 6, 140, 140, 140, 140, 140, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 140, 18, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 16, 6, 6, 140, 140, 140
	                        DB  140, 42, 140, 42, 42, 42, 42, 42, 42, 42, 42, 140, 137, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 16, 137, 6, 6, 6, 6, 6, 6, 6, 6, 140, 140, 140, 140
	                        DB  140, 6, 114, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 186, 114, 114, 114, 114, 210, 114, 137, 138, 6, 6, 6, 137, 16, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC







	APPLE_X                 DW  236,103,	353,211,53,	442,546,490,501,257,404,68,	417,169,252,329,292,197,43,	344,481,514,313,554,484,261,524,312,544,260
	APPLE_Y                 DW  332,254,103,256,189,212,133,175,81,256,117,352,287,240,339,308,290,313,353,281,89,312,114,122,288,324,124,127,198,114
	APPLES_NUM              DW  30
	APPLE_TYPE              DB  0                                                                                                                                                                                                     	;0=RED , 1=GOLDEN                                                                                                                                                                                                 	; 30 POSSIBLE LOCATIONS FOR APPLES
	CURR_APPLE_INDEX        DW  0
	NUM_TO_GET_GOLDEN       DB  0                                                                                                                                                                                                     	; THAT REPRESENT WHICH APPLE IS DISPLAYED CURRENLTY
	CRITICAL_DIST           DW  28                                                                                                                                                                                                    	; SNAKE EATS AN APPLE IF THE DISTANCE BETWEEN SNAKE_HEAD_CENTER AND APPLE_CENTER IS 22




	SNAKE_LEN_ARR           DW  2,2
	MAX_TOTAL_LEN           DW  9
	MIN_TOTAL_LEN           DW  2
	CHOSEN_SNAKE            DW  ?
	;DATA ABOUT SNAKE SHAPE

	BODY_SHAPE2             DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,5,5,5,5,5,5,5,5,5,5,5,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,5,5,5,5,5,5,5,5,5,5,5,5,5,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,BGC,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,BGC,BGC,BGC
	                        DB  BGC,BGC,5,5,5,5,5,5,5,5,5,5,7,7,7,7,7,7,7,5,5,5,5,5,5,5,5,5,5,BGC,BGC
	                        DB  BGC,BGC,5,5,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,7,5,5,5,5,5,5,5,5,5,BGC,BGC
	                        DB  BGC,BGC,5,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,7,7,7,5,5,5,5,5,5,5,5,BGC,BGC
	                        DB  BGC,BGC,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,7,7,7,7,7,5,5,5,5,5,5,5,BGC,BGC
	                        DB  BGC,BGC,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,7,7,7,7,7,5,5,5,5,5,5,5,BGC,BGC
	                        DB  BGC,BGC,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,7,7,7,7,7,5,5,5,5,5,5,5,BGC,BGC
	                        DB  BGC,BGC,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,7,7,7,7,7,5,5,5,5,5,5,5,BGC,BGC
	                        DB  BGC,BGC,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,7,7,7,7,7,5,5,5,5,5,5,5,BGC,BGC
	                        DB  BGC,BGC,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,7,7,7,7,7,5,5,5,5,5,5,5,BGC,BGC
	                        DB  BGC,BGC,5,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,7,7,7,5,5,5,5,5,5,5,5,BGC,BGC
	                        DB  BGC,BGC,5,5,5,5,5,5,5,5,5,7,7,7,7,7,7,7,7,7,5,5,5,5,5,5,5,5,5,BGC,BGC
	                        DB  BGC,BGC,5,5,5,5,5,5,5,5,5,5,7,7,7,7,7,7,7,5,5,5,5,5,5,5,5,5,5,BGC,BGC
	                        DB  BGC,BGC,BGC,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,BGC,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,5,5,5,5,5,5,5,5,5,5,5,5,5,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,5,5,5,5,5,5,5,5,5,5,5,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC

	BODY_SHAPE1             DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,2,2,2,2,2,2,2,2,2,2,2,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,2,2,2,2,2,2,2,2,2,2,2,2,2,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,BGC,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,BGC,BGC,BGC
	                        DB  BGC,BGC,2,2,2,2,2,2,2,2,2,2,7,7,7,7,7,7,7,2,2,2,2,2,2,2,2,2,2,BGC,BGC
	                        DB  BGC,BGC,2,2,2,2,2,2,2,2,2,7,7,7,7,7,7,7,7,7,2,2,2,2,2,2,2,2,2,BGC,BGC
	                        DB  BGC,BGC,2,2,2,2,2,2,2,2,7,7,7,7,7,7,7,7,7,7,7,2,2,2,2,2,2,2,2,BGC,BGC
	                        DB  BGC,BGC,2,2,2,2,2,2,2,7,7,7,7,7,7,7,7,7,7,7,7,7,2,2,2,2,2,2,2,BGC,BGC
	                        DB  BGC,BGC,2,2,2,2,2,2,2,7,7,7,7,7,7,7,7,7,7,7,7,7,2,2,2,2,2,2,2,BGC,BGC
	                        DB  BGC,BGC,2,2,2,2,2,2,2,7,7,7,7,7,7,7,7,7,7,7,7,7,2,2,2,2,2,2,2,BGC,BGC
	                        DB  BGC,BGC,2,2,2,2,2,2,2,7,7,7,7,7,7,7,7,7,7,7,7,7,2,2,2,2,2,2,2,BGC,BGC
	                        DB  BGC,BGC,2,2,2,2,2,2,2,7,7,7,7,7,7,7,7,7,7,7,7,7,2,2,2,2,2,2,2,BGC,BGC
	                        DB  BGC,BGC,2,2,2,2,2,2,2,7,7,7,7,7,7,7,7,7,7,7,7,7,2,2,2,2,2,2,2,BGC,BGC
	                        DB  BGC,BGC,2,2,2,2,2,2,2,2,7,7,7,7,7,7,7,7,7,7,7,2,2,2,2,2,2,2,2,BGC,BGC
	                        DB  BGC,BGC,2,2,2,2,2,2,2,2,2,7,7,7,7,7,7,7,7,7,2,2,2,2,2,2,2,2,2,BGC,BGC
	                        DB  BGC,BGC,2,2,2,2,2,2,2,2,2,2,7,7,7,7,7,7,7,2,2,2,2,2,2,2,2,2,2,BGC,BGC
	                        DB  BGC,BGC,BGC,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,BGC,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,2,2,2,2,2,2,2,2,2,2,2,2,2,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,2,2,2,2,2,2,2,2,2,2,2,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC
	                        DB  BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC,BGC

	FIRE                    DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 67, 91, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, 67, 43, 67, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 91, 43, 43, 14, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 91, 43, 43, 43, 14, 91, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 90, 43, 43, 43, 43, 14, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 67, 43, 43, 43, 43, 43, 66, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 66
	                        DB  43, 43, 43, 43, 43, 43, 67, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 90, 43, 43, 43, 43, 43, 43, 43, 43, 90, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 67, 90, BGC, BGC, 66, 42, 42, 42, 43, 43, 43, 42, 42, 66, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, 66, 66, BGC, 67, 42, 42, 42, 42, 43, 43, 43, 42, 42, 42, 90, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 43, 43
	                        DB  90, 42, 42, 42, 42, 42, 42, 43, 43, 43, 42, 42, 66, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 90, 43, 43, 42, 42, 42, 42, 42, 42, 42, 43, 43
	                        DB  43, 42, 42, 42, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 14, 43, 42, 42, 42, 42, 42, 42, 42, 42, 43, 43, 43, 42, 42, 42, 90, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 67, 43, 42, 42, 42, 42, 42, 42, 42, 42, 43, 43, 43, 43, 42, 42, 42, 89, 89, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 91
	                        DB  43, 43, 42, 42, 42, 42, 42, 42, 42, 43, 43, 43, 43, 43, 42, 42, 42, 66, 42, 89, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 14, 43, 42, 42, 42, 42, 42, 42, 42, 42
	                        DB  43, 43, 43, 43, 42, 42, 42, 42, 65, 42, 65, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 91, 43, 43, 42, 42, 42, 42, 42, 42, 42, 43, 43, 43, 43, 42, 42, 42, 42, 42, 42
	                        DB  42, 42, 90, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 67, 43, 43, 41, 41, 41, 41, 41, 42, 43, 43, 43, 43, 42, 42, 41, 41, 41, 41, 41, 41, 41, 89, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, 14, 43, 42, 41, 41, 41, 41, 42, 42, 43, 43, 43, 42, 42, 41, 41, 41, 41, 41, 41, 41, 41, 66, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 43, 43, 42, 41, 41, 41, 41
	                        DB  42, 42, 42, 42, 42, 42, 41, 41, 41, 41, 41, 41, 41, 41, 41, 89, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 43, 43, 42, 41, 41, 41, 41, 42, 42, 42, 42, 42, 41, 41, 42, 41
	                        DB  41, 41, 41, 41, 41, 41, 89, 90, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 14, 43, 42, 41, 41, 41, 42, 42, 42, 42, 42, 42, 41, 41, 41, 42, 41, 41, 41, 41, 41, 12, 88, 66, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, 67, 43, 43, 41, 41, 41, 42, 42, 42, 42, 42, 42, 41, 41, 42, 42, 42, 41, 41, 41, 41, 12, 42, 65, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 91, 43, 43
	                        DB  41, 41, 41, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 41, 41, 41, 41, 42, 41, 89, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 91, 67, 43, 42, 41, 41, 42, 42, 42, 42, 42, 42
	                        DB  42, 42, 42, 42, 42, 41, 41, 41, 41, 42, 42, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 67, 14, 14, 43, 41, 40, 41, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 41, 40, 41, 42
	                        DB  42, 66, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 14, 43, 43, 42, 41, 41, 42, 42, 42, 42, 42, 42, 42, 42, 42, 42, 41, 41, 42, 42, 65, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, 91, 43, 43, 43, 42, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 41, 42, 42, 65, 29, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 91, 14, 43, 43, 42, 41
	                        DB  41, 41, 41, 41, 41, 41, 41, 41, 41, 42, 43, 66, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 90, 66, 42, 42, 41, 41, 41, 41, 41, 41, 41, 42, 42
	                        DB  43, 90, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 90, 66, 65, 42, 42, 41, 41, 41, 42, 66, 67, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC
						 
						 
	EDGE                    DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 31, 29, 29, 29, 30, 31, 31, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 29, 27, 26, 25, 25, 25
	                        DB  25, 26, 27, 28, 30, 31, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 28, 26, 25, 24, 23, 23, 24, 24, 24, 24, 25, 27, 29, 30, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 28, 27
	                        DB  25, 23, 22, 23, 24, 25, 25, 25, 25, 24, 24, 26, 28, 30, BGC, BGC, BGC, BGC, BGC, BGC, 29, 28, 26, 24, 22, 23, 25, 26, 26, 26, 26, 26, 25, 24, 24, 26, 28, 30, BGC, BGC
	                        DB  BGC, BGC, BGC, 30, 28, 26, 23, 23, 25, 26, 26, 26, 26, 26, 26, 26, 25, 23, 24, 26, 28, BGC, BGC, BGC, BGC, BGC, 30, 29, 27, 24, 25, 25, 26, 26, 26, 26, 26, 26, 26, 25
	                        DB  24, 23, 25, 28, BGC, BGC, BGC, BGC, BGC, 31, 29, 27, 26, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 25, 24, 25, 28, 30, BGC, BGC, BGC, BGC, BGC, BGC, 26, 26, 26, 26, 26, 26
	                        DB  26, 26, 26, 26, 26, 26, 26, 25, 25, 31, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 26, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 25, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, 26, 26, 26, 26, 26, 27, 26, 26, 26, 26, 26, 26, 26, 26, 26, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 25, 26, 26, 26, 27, 27, 27, 26, 26, 26, 26
	                        DB  26, 26, 26, 25, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 26, 26, 26, 26, 27, 27, 27, 27, 26, 26, 26, 26, 26, 25, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 25, 26, 26
	                        DB  26, 26, 26, 26, 26, 26, 26, 26, 26, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 25, 25, 25, 25, 25, 26, 26, 26, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC

	FREEZED                 DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	                        DB  0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 126, 150, 126, 0
	                        DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 197, 198, 150, 79, 150, 198, 197, 0, 0, 0, 0, 0, 0, 0, 0
	                        DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 126, 148, 148, 78, 172, 172, 151, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	                        DB  0, 0, 0, 0, 0, 0, 0, 151, 25, 78, 78, 102, 79, 151, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 126, 151
	                        DB  148, 78, 172, 151, 126, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 16, 126, 126, 126, 0, 0, 0, 151, 79, 79, 78, 78, 79, 151, 0, 0, 0, 126
	                        DB  151, 126, 16, 16, 0, 0, 0, 0, 0, 0, 0, 198, 151, 151, 150, 172, 151, 126, 126, 0, 126, 172, 79, 78, 78, 172, 126, 0, 126, 126, 150, 79, 150, 150, 151, 198, 0, 0, 0, 0
	                        DB  0, 0, 198, 148, 79, 9, 79, 150, 148, 150, 16, 199, 126, 148, 78, 172, 126, 199, 16, 150, 24, 150, 103, 79, 78, 172, 198, 0, 0, 0, 0, 0, 0, 198, 151, 172, 78, 78, 148, 79
	                        DB  149, 197, 150, 172, 78, 103, 103, 79, 149, 198, 148, 103, 24, 102, 102, 24, 151, 198, 0, 0, 0, 0, 0, 0, 0, 151, 79, 78, 79, 78, 78, 148, 148, 79, 79, 172, 149, 172, 78, 78
	                        DB  24, 172, 102, 102, 78, 103, 79, 151, 0, 0, 0, 0, 0, 0, 0, 0, 151, 172, 150, 148, 78, 78, 78, 78, 172, 151, 126, 151, 126, 151, 24, 103, 103, 103, 102, 172, 149, 24, 151, 0
	                        DB  0, 0, 0, 0, 0, 0, 0, 197, 198, 126, 24, 24, 150, 79, 24, 126, 150, 25, 78, 172, 151, 126, 79, 78, 149, 24, 25, 126, 198, 198, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	                        DB  126, 126, 197, 151, 79, 149, 126, 79, 78, 24, 79, 172, 126, 172, 78, 151, 197, 126, 126, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 151, 79, 148, 126, 78, 24
	                        DB  198, 148, 79, 126, 172, 78, 150, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 126, 126, 197, 151, 79, 149, 126, 79, 78, 172, 79, 25, 126, 172, 78, 151, 197, 126
	                        DB  126, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 197, 198, 126, 172, 148, 150, 79, 172, 126, 150, 25, 78, 24, 150, 126, 79, 78, 150, 24, 25, 126, 198, 197, 0, 0, 0, 0, 0, 0
	                        DB  0, 0, 151, 148, 150, 148, 78, 79, 78, 78, 148, 126, 126, 151, 126, 151, 24, 103, 103, 103, 103, 172, 150, 172, 151, 0, 0, 0, 0, 0, 0, 0, 0, 151, 79, 79, 79, 78, 78, 148
	                        DB  24, 78, 79, 149, 149, 172, 78, 103, 24, 172, 102, 102, 79, 103, 79, 151, 0, 0, 0, 0, 0, 0, 0, 198, 126, 172, 78, 78, 172, 79, 149, 197, 149, 25, 78, 78, 103, 79, 149, 198
	                        DB  148, 103, 24, 102, 102, 24, 151, 198, 0, 0, 0, 0, 0, 0, 198, 148, 78, 79, 79, 150, 24, 150, 16, 199, 126, 148, 78, 172, 126, 199, 16, 149, 24, 150, 103, 79, 78, 172, 198, 0
	                        DB  0, 0, 0, 0, 0, 198, 151, 150, 150, 79, 151, 126, 126, 0, 126, 149, 79, 78, 78, 148, 126, 0, 126, 126, 150, 79, 150, 150, 151, 198, 0, 0, 0, 0, 0, 0, 0, 16, 0, 126
	                        DB  151, 126, 0, 0, 0, 151, 79, 79, 78, 78, 79, 151, 0, 0, 0, 126, 151, 126, 0, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 126, 151, 148, 78
	                        DB  172, 151, 126, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 151, 24, 78, 78, 102, 79, 151, 0, 0, 0, 0, 0, 0
	                        DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 151, 172, 172, 78, 24, 24, 151, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	                        DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 198, 198, 150, 79, 150, 198, 198, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	                        DB  0, 0, 126, 150, 126, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0
	                        DB  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	                        DB  0



body_freezed                DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, 16, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 126, 150, 126, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 197, 198, 150, 79, 150, 198, 197, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 126, 148, 148, 78, 172, 172, 151, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, 151, 25, 78, 78, 102, 79, 151, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 126, 151
	                        DB  148, 78, 172, 151, 126, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 16, 16, 126, 126, 126, BGC, BGC, BGC, 151, 79, 79, 78, 78, 79, 151, BGC, BGC, BGC, 126
	                        DB  151, 126, 16, 16, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 198, 151, 151, 150, 172, 151, 126, 126, BGC, 126, 172, 79, 78, 78, 172, 126, BGC, 126, 126, 150, 79, 150, 150, 151, 198, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, 198, 148, 79, 9, 79, 150, 148, 150, 16, 199, 126, 148, 78, 172, 126, 199, 16, 150, 24, 150, 103, 79, 78, 172, 198, BGC, BGC, BGC, BGC, BGC, BGC, 198, 151, 172, 78, 78, 148, 79
	                        DB  149, 197, 150, 172, 78, 103, 103, 79, 149, 198, 148, 103, 24, 102, 102, 24, 151, 198, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 151, 79, 78, 79, 78, 78, 148, 148, 79, 79, 172, 149, 172, 78, 78
	                        DB  24, 172, 102, 102, 78, 103, 79, 151, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 151, 172, 150, 148, 78, 78, 78, 78, 172, 151, 126, 151, 126, 151, 24, 103, 103, 103, 102, 172, 149, 24, 151, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, 197, 198, 126, 24, 24, 150, 79, 24, 126, 150, 25, 78, 172, 151, 126, 79, 78, 149, 24, 25, 126, 198, 198, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  126, 126, 197, 151, 79, 149, 126, 79, 78, 24, 79, 172, 126, 172, 78, 151, 197, 126, 126, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 151, 79, 148, 126, 78, 24
	                        DB  198, 148, 79, 126, 172, 78, 150, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 126, 126, 197, 151, 79, 149, 126, 79, 78, 172, 79, 25, 126, 172, 78, 151, 197, 126
	                        DB  126, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 197, 198, 126, 172, 148, 150, 79, 172, 126, 150, 25, 78, 24, 150, 126, 79, 78, 150, 24, 25, 126, 198, 197, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, 151, 148, 150, 148, 78, 79, 78, 78, 148, 126, 126, 151, 126, 151, 24, 103, 103, 103, 103, 172, 150, 172, 151, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 151, 79, 79, 79, 78, 78, 148
	                        DB  24, 78, 79, 149, 149, 172, 78, 103, 24, 172, 102, 102, 79, 103, 79, 151, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 198, 126, 172, 78, 78, 172, 79, 149, 197, 149, 25, 78, 78, 103, 79, 149, 198
	                        DB  148, 103, 24, 102, 102, 24, 151, 198, BGC, BGC, BGC, BGC, BGC, BGC, 198, 148, 78, 79, 79, 150, 24, 150, 16, 199, 126, 148, 78, 172, 126, 199, 16, 149, 24, 150, 103, 79, 78, 172, 198, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, 198, 151, 150, 150, 79, 151, 126, 126, BGC, 126, 149, 79, 78, 78, 148, 126, BGC, 126, 126, 150, 79, 150, 150, 151, 198, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 16, BGC, BGC
	                        DB  151, 126, BGC, BGC, BGC, 151, 79, 79, 78, 78, 79, 151, BGC, BGC, BGC, 126, 151, 126, BGC, 16, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 126, 151, 148, BGC
	                        DB  172, 151, 126, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 151, 24, 78, 78, 102, 79, 151, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 151, 172, 172, 78, 24, 24, 151, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 198, 198, 150, 79, 150, 198, 198, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, 126, 150, 126, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, 16, BGC, BGC, BGC, BGC, BGC
	                        DB  BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC


 line db "Notification bar:",10,13,
               "--------------------------------------------------------------------------------",
          10,13,'$'


	FIRE_X                  DW  445,464,163,103,48,510,372,95,166,519,392,124,583,290,248,285,588,53,378,95,133,554,281,444,134,146,76,292,187,361
	FIRE_Y                  DW  301,96,118,113,295,161,306,137,257,119,290,167,291,241,102,321,144,87,197,163,92,85,292,162,207,269,130,218,203,300
	CURR_FIRE_INDEX         DW  0
	FIRES_NUM               DW  30

	; TEMPS FOR PROC OF DRAWING HEAD

	TEMPHEAD                DW  ?
	TEMP_HEAD_X             DW  100
	TEMP_HEAD_Y             DW  100                                                                                                                                                                                                   	;MSLN
	TEMP_HEAD_TRAN_X        DW  ?
	TEMP_HEAD_TRAN_Y        DW  ?


	; TEMPS FOR PROC OF DRAWING BODY

	TEMP_BODY_SHAPE         DW  ?
	INIT_SQUARE_X           DW  ?
	INIT_SQUARE_Y           DW  ?
	INIT_SQUARE_TRAN_X      DW  ?
	INIT_SQUARE_TRAN_Y      DW  ?
	TEMP_COLOR              DB  ?
	

	TEMP_BUFFER1            DB  ?
	TEMP_BUFFER2            DB  ?


	PLAYER1_SCORE           DW  0
	PLAYER2_SCORE           DW  0

	temp1_score             dw  0
	temp2_score             dw  0
	temp_to_addation        db  0
	temp_to_reset_score1    dw  0
	temp_to_reset_score2    dw  0

	LEVEL1_SPEEDCX          DW  0002H
	LEVEL1_SPEEDDX          DW  00FFH
	LEVEL2_SPEEDCX          DW  0001H
	LEVEL2_SPEEDDX          DW  0FFFFH

	NUM_C_EAT_SNAKE1        DW  0
	NUM_C_EAT_SNAKE2        DW  0
	
	POWER_UP1_PENALITY      DW  75
	SNAKE1_FREEZE           DW  0
	SNAKE2_FREEZE           DW  0


	SNAKE1_HEAD_DIRECTION   DW  0                                                                                                                                                                                                     	; UP=0 ; DOWN=1 ;  RIGHT=2 ; LEFT=3
	SNAKE2_HEAD_DIRECTION   DW  0
	SNAKE1_HEAD_OFFSETS     DW  10 DUP(?)
	SNAKE2_HEAD_OFFSETS     DW  10 DUP(?)
	
	BITE_SENARIO            DW  1
	TEMP                    DW  1
	time                    DB  ?
 
	DISPLAYED_SECONDS       DB  59
	DISPLAYED_MINUTES       DB  ?

	LAST_SYS_SECOND         DB  ?


	;ISRAA TEMPS
	MINUTES                 DB  ?
	SECONDS                 DB  ?
	temp_sec1               DB  ?
	temp_sec2               DB  ?





	END_OF_THE_GAME         DW  0                                                                                                                                                                                                     	; IF 1 , GAME IS ENDED
	;rules

	GAME_START_STR          DB  '  ',0ah,0dh
	                        db  '                                                                    ',0ah,0dh
	                        db  '                                                                    ',0ah,0dh
	                        db  '                                                                    ',0ah,0dh
	                        db  '                                                                    ',0ah,0dh
	                        db  '                                                                    ',0ah,0dh
	                        db  '                                                                    ',0ah,0dh
	                        db  '                                                                    ',0ah,0dh
	                        DB  '                ====================================================',0ah,0dh
	                        DB  '               ||                     *RULES*                       ||',0ah,0dh
	                        DB  '               ||                                                   ||',0ah,0dh
	                        DB  '               ||   Apple increase score by 5                       ||',0ah,0dh
	                        DB  '               ||   Fire decrease score  by 5                       ||',0ah,0dh
	                        DB  '               ||-------------------------------------------------- ||',0ah,0dh
	                        DB  '               ||  You have three powers UP                         ||',0ah,0dh
	                        DB  '               ||  *Freeze                                          ||',0ah,0dh
	                        DB  '               ||  *Bite                                            ||',0ah,0dh
							db  '               ||  *Golden apple (+5 for you, -5 for your rival)    ||',0ah,0dh
	                        DB  '               ||                   *GOOD LUCK*                     ||',0ah,0dh
	                        DB  '                ====================================================',0ah,0dh
	                        DB  '$',0ah,0dh


	game_stat_text          DB  '  ', 0ah,0dh
  
	                        DB  '                                                                 ',0ah,0dh
	                        DB  '                                *   SNAKE RIVALS     *          ',0ah,0dh
	                        DB  '                            ----------------------------------    ' ,0ah,0dh
  
	                        DB  '$',0ah,0dh
	game_end                db  "GAME OVER $"
	game_cong               DB  "Congratulations $  "
	c_dl                    db  ?
	c_dh                    db  ?
	temp_score_t            dw  ?
	equlity                 db  "THE TWO PLAYERS TIED $"
	snake_text              db  "SNAKE RIVALS $"
	player_num              db  ?
	to_send                 db  100
	LVL_SPEED               DW  ?
	LVL                     DB  1



	TEMP_SNAKE1_X           DW  15 DUP (500)
	TEMP_SNAKE1_Y           DW  15 DUP (210)
	TEMP_SNAKE2_X           DW  15 DUP (160)
	TEMP_SNAKE2_Y           DW  15 DUP (210)
	TEMP_CURR_FIRE_INDEX    DW  29
	TEMP_CURR_APPLE_INDEX   DW  29
	TEMP_SNAKE_LEN_ARR      DW  2 ,2
	counter_chat            db  0
	counter_chat2           db  0
	inc_dh                  db  0
	inc_dh2                 db  0

	chat_countre_send       db  0
	chat_countre_recieve    db  0

	value1                  db  ?

	NAME_XCHGED_BEFORE      db  0
	temp_offset_for_name_s  dw  ?
	temp_offset_for_name_s2 dw  ?
	open_chat               db  0
	check_backspace         db  0

.CODE
MAIN PROC FAR
	                               MOV                AX,@DATA
	                               MOV                DS,AX
	                               portinitialization
	                               mov                si,offset snake_text
	                               mov                bl,02h
	                               call               game_over_text
	                               call               print_Rules
	CONT_THE_GAME:                 
	
	                               CALL               RESET_GAME
	                               CALL               BEFORE_START_SETUP
	                               cmp                player_num,2
	                               jz                 p_2
	                               CALL               ask_for_time



	; ASK FOR LEVEL
	                               CALL               ASK_FOR_LVL
	                               CMP                LVL,1
	                               JNE                LVL2
	                               MOV                LVL_SPEED,0FFFFH
	                               JMP                LVL_label
	LVL2:                          
	                               MOV                LVL_SPEED,800FH
	LVL_label:                     

	; ENTER GRAPHICS MODE
	                               MOV                AL,02H
	                               MOV                AH,4FH
	                               MOV                Bx,0100H
	                               INT                10H
	                               CALL               DRAW_BACK_G
	                               CALL               DRAW_INIT_SNAKE
	                               CALL               DRAW_STATUS_BAR

	; IF PLAYER NUMBER IS "ONE" CALL MOVE_SNAKE
	                               CALL               MOVE_SNAKE
	                               jmp                sc_2
	;ELSE  CALL MOVE_SNAKE_P2
	P_2:                           
	                               MOV                AL,02H
	                               MOV                AH,4FH
	                               MOV                Bx,0100H
	                               INT                10H
	; mov si , offset name_s+2
	; mov di , offset name_s2+2
	; mov cx , 15
	; xcg:
	;  MOV    AL,[name_s+2]
	;   XCHG   AL,[name_s2+2]
	;  MOV    [name_s],AL
	;loop xcg
	                               CALL               DRAW_BACK_G
	                               CALL               DRAW_INIT_SNAKE
	                               CALL               DRAW_STATUS_BAR
	                               CALL               MOVE_SNAKE_P2
	sc_2:                          
	                               mov                si,offset game_end
	                               mov                bl,04h
	                               call               game_over_text
	                               call               result_of_end
	                               JMP                CONT_THE_GAME
						
	
	INFF:                          
	                               JMP                INFF
	                               HLT
MAIN ENDP

RESET_GAME PROC NEAR
	                               mov                cx,15
	                               mov                BX,2
	lp1:                           
	                               mov                [name_s+bx],'$'
	                               INC                BX
	                               loop               lp1

	                               mov                cx,15
	                               mov                BX,2
	lp2:                           
	                               mov                [name_s2+bx],'$'
	                               INC                BX
	                               loop               lp2
	                               MOV                SNAKE1_X ,500                   	; INTITALLY
	                               MOV                SNAKE1_Y ,210
	                               MOV                SNAKE2_X ,160                   	; INTITALLY
	                               MOV                SNAKE2_Y ,210
	                               MOV                SNAKE_LEN_ARR[0],2
	                               MOV                SNAKE_LEN_ARR[2],2
	                               MOV                TEMP_BUFFER1 , 0
	                               MOV                TEMP_BUFFER2 , 0
	                               MOV                SNAKE1_HEAD_DIRECTION , 0
	                               MOV                SNAKE2_HEAD_DIRECTION , 0
	                               MOV                CURR_APPLE_INDEX , 0

	                               MOV                CURR_FIRE_INDEX , 0
	                               MOV                TEMP_HEAD_X ,100
	                               MOV                TEMP_HEAD_Y ,100
	                               MOV                PLAYER1_SCORE , 0
	                               MOV                PLAYER2_SCORE ,0

	                               MOV                temp1_score,0
	                               MOV                temp2_score ,0
	                               MOV                temp_to_addation   ,0
	                               MOV                temp_to_reset_score1 , 0
	                               MOV                temp_to_reset_score2  ,0
	                               MOV                NUM_C_EAT_SNAKE1 , 0
	                               MOV                NUM_C_EAT_SNAKE2  , 0
	                               MOV                SNAKE1_FREEZE  ,0
	                               MOV                SNAKE2_FREEZE  , 0
	                               MOV                BITE_SENARIO,  1
	                               MOV                TEMP  , 1
	                               MOV                DISPLAYED_SECONDS , 59
	                               MOV                END_OF_THE_GAME , 0
	                               MOV                NUM_TO_GET_GOLDEN  ,0
								   mov                 NAME_XCHGED_BEFORE,0
	                               RET
RESET_GAME ENDP
print_Rules proc near
	                               mov                ax,0600h
	                               mov                cx,0
	                               mov                dx,184fh
	                               int                10h
	                               mov                ax, 3
	                               int                10h
	                               mov                ah,2
	                               mov                dx,0625h
	                               int                10h

	                               mov                ah,09
	                               mov                dx, offset game_stat_text
	                               int                21h
	        
	                               mov                dx,0900h
	                               int                10h

	                               mov                ah,09
	                               mov                dx ,offset GAME_START_STR
	                               int                21h


	                               mov                ah,0
	                               int                16h

	                               RET
print_Rules ENDP
game_over_text proc near

 
	                               mov                ax,0600h
	                               mov                cx,0
	                               mov                dx,184fh
	                               int                10h
	                               mov                ax, 13
	                               int                10h
	                   
	                               mov                dl,0fh
	                               mov                dh,9h                           	;row
	                               mov                bh,0
	                               mov                ah,02h
	                               int                10h
	        
	next_char:                     mov                ah,2
	                               int                10h

	                               mov                ah,09
	                               mov                bh,0
	                               mov                al,[si]
	                               mov                cx,1h
	                   

	        
	                               mov                ah,0eh
	                               int                10h
	;
	                               inc                dx
	                               inc                si
	                          
	                               mov                di,si
	                               inc                si
	                               mov                al,[si]
	                               cmp                al,'$'
	                               mov                si,di
	                               jnz                next_char
	                               MOV                CX,0010H
	                               MOV                DX,0000H
	                               MOV                AH,86H
	                               INT                15H

	                               RET

game_over_text endp

result_of_end proc near
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;clean screen;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	                               mov                ax,0600h
	                               mov                cx,0
	                               mov                dx,184fh
	                               int                10h
	                               mov                ax,13
	                               int                10h
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	                  
	                               mov                dx,00
	                               mov                ah,09
	                               mov                bh,0
	                               mov                al,[si]
	                               mov                cx,1h
	                               mov                bl,0

	                               int                10h
	                               mov                si,offset name_s+4
	
	                               mov                dx,0240h
	                               mov                bl,2
	                               call               player_p
	
	                               mov                si,offset name_s2+4
	
	                               mov                dx,0202h
	                               mov                bl,5
	                               call               player_p
	                               mov                al,03
	                               mov                c_dh,al
	                               mov                al,06h
	                               mov                c_dl,al
	                               mov                bx,PLAYER2_SCORE
	                               mov                temp_score_t,bx
	                               call               score_print_2
					
					
						
	
	                    

	;;;;;;;;;;player2;;;;;;;
	                               mov                al,03
	                               mov                c_dh,al
						
	                               mov                al,44h
	                               mov                c_dl,al
	                               mov                bx,PLAYER1_SCORE
	                               mov                temp_score_t,bx
	                               call               score_print_2
	                               mov                ax,PLAYER1_SCORE
	                               cmp                ax,PLAYER2_SCORE
	                               jz                 eqq
	                               jnz                cong


	eqq:                           mov                si,offset equlity
	                               mov                dx,080ah
	                               call               print_string
	                 
	                   
	;2DC6C0 = 3 SEC
	                               MOV                AL,0
	                               MOV                CX,002DH
	                               MOV                DX,0C6C0H
	                               MOV                AH,86H
	                               INT                15H
	                               ret
	cong:                          
						
	                               clc
	                               mov                ax,PLAYER1_SCORE
	                               cmp                ax,PLAYER2_SCORE

	                               jc                 p_p_2
	                               jnc                p_p_1
	p_p_2:                         mov                si,offset name_s2+4
	
	                               mov                dx, 0a0fh
	                               mov                bl,5
	                               call               player_p
	                               mov                si,offset game_cong
	                               mov                dx,080dh
	                               call               print_string
						


	                   
	                               mov                al,0ch
	                               mov                c_dh,al
	                               mov                al,13h
	                               mov                c_dl,al
	                               mov                bx,PLAYER2_SCORE
	                               mov                temp_score_t,bx
	                               call               score_print_2
	                               mov                si,offset game_cong
	                               mov                dx,080dh
	                               call               print_string
						 
				
					
	                   
	                               MOV                AL,0
	                               MOV                CX,002DH
	                               MOV                DX,0C6C0H
	                               MOV                AH,86H
	                               INT                15H
	                               ret

 
	p_p_1:                         

	                               mov                si,offset name_s+4
	
	                               mov                dx, 0a0fh
	                               mov                bl,2
	                               call               player_p


	                   
	                               mov                al,0ch
	                               mov                c_dh,al
	                               mov                al,13h
	                               mov                c_dl,al
	                               mov                bx,PLAYER1_SCORE
	                               mov                temp_score_t,bx
	                               call               score_print_2
	                               mov                si,offset game_cong
	                               mov                dx,080ah
	                               call               print_string
					
	                       
	                               MOV                AL,0
	                               MOV                CX,002DH
	                               MOV                DX,0C6C0H
	                               MOV                AH,86H
	                               INT                15H
	                               ret

result_of_end endp

score_print_2 proc near

	NEXT_DIGIT_4:                  mov                ax,temp_score_t
	                               add                temp_to_addation ,1
	                               mov                bx,10
	                               mov                dx,0
	                               div                bx
	                               mov                temp_score_t,ax
	                               mov                temp2_score,dx
	                               mov                dl,c_dl                         	;column
					
	                               sub                dl,temp_to_addation

	                               mov                dh,c_dh                         	;row
	                               mov                bh,0
	                               mov                ah,02h
	                               int                10h
    
	;score of player 2
	                               mov                bl,4                            	;color
	                               mov                al,byte ptr temp2_score
	                               add                al,30h
	                               mov                ah,0eh                          	;
			 
	                               int                10h
	                               mov                ax,temp_score_t
	                               cmp                ax,0
	                               jg                 NEXT_DIGIT_4

	                               mov                ax,temp_to_reset_score2
	                               mov                temp_score_t,ax
	                               mov                al,0
	                               mov                temp_to_addation ,al

	                               ret
score_print_2 endp




player_p proc near


	en6:                           
	                               mov                ah,2
	                               int                10h

	                               mov                ah,09
	                               mov                bh,0
	                               mov                al,[si]
	                               mov                cx,1h
	;mov                bl,3
						          
	                               int                10h

	;
	                               inc                dx
	                               inc                si
	                          
	                               mov                cx,si
	                               inc                si
	                               mov                al,[si]
	                               cmp                al,'$'
	                               mov                si,cx
	                               jnz                en6


	                               ret
player_p endp


print_string proc near

	                   
	                    

	en2:                           
	            
	                               mov                ah,2
	                               int                10h
	                  
	                               mov                ah,09
	                               mov                bh,0
	                               mov                al,[si]
	                               mov                cx,1h
	                               mov                bl,0fh
	                               mov                ah,0eh
	                               int                10h
	                               inc                dx
	                               inc                si
	;
	                 
	                          
	                               mov                bx,si
	                               inc                si
	                               mov                al,[si]
	                               cmp                al,24h
	                               mov                si,bx
	                               jnz                en2


	                               ret
print_string endp



print_score_player2 proc  near

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;clear last position

	                               mov                cx,4
	                               mov                dx,011bh
	clear_digits:                  mov                bh,0
	                               mov                ah,02h
	                               int                10h
    
	;score of player 1
	                               mov                bl,0                            	;color
	                               mov                al,0
	                               add                al,30h
	                               mov                ah,0eh                          	;
			
	                               int                10h
	                               dec                dx
	                               loop               clear_digits
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	                               push               PLAYER2_SCORE
	                               mov                ax,  PLAYER2_SCORE
	                               mov                temp_to_reset_score1,ax
	Next_digit:                    mov                ax, PLAYER2_SCORE
	                               add                temp_to_addation ,1
	                               mov                bx,10
	                               mov                dx,0
	                               div                bx
	                               mov                PLAYER2_SCORE,ax
	                               mov                temp1_score,dx
	                               mov                dl,1bh                          	;column
					
	                               sub                dl,temp_to_addation

	                               mov                dh,1h                           	;row
	                               mov                bh,0
	                               mov                ah,02h
	                               int                10h
    
	;score of player 1
	                               mov                bl,4                            	;color
	                               mov                al,byte ptr temp1_score
	                               add                al,30h
	                               mov                ah,0eh                          	;
			
	                               int                10h
	                               mov                ax,PLAYER2_SCORE
	                               cmp                ax,0
	                               jg                 Next_digit

	                               mov                ax,temp_to_reset_score1
	                               mov                PLAYER2_SCORE,ax
	                               mov                al,0
	                               mov                temp_to_addation ,al
	                               pop                PLAYER2_SCORE
	                               ret

print_score_player2 ENDP


Print_time proc near



	                               mov                ah, 2ch
	                               int                21h                             	;RETURN SECONDS IN DH
	                               CMP                DH,LAST_SYS_SECOND
	                               JE                 PRINT_CURR_TIME
	                               MOV                LAST_SYS_SECOND,DH
	                               CMP                DISPLAYED_SECONDS,0
	                               JE                 RESET_SECONDS
	GO_TO_DEC_SECONDS:             
	                               DEC                DISPLAYED_SECONDS
	                               JMP                PRINT_CURR_TIME

	                               JMP                PRINT_CURR_TIME
	RESET_SECONDS:                 
	                               CMP                DISPLAYED_MINUTES,0
	                               JZ                 TIME_OUT
	                               DEC                DISPLAYED_MINUTES
	                               MOV                DISPLAYED_SECONDS,60
	                               JMP                GO_TO_DEC_SECONDS

	PRINT_CURR_TIME:               
	                               MOV                AL,DISPLAYED_MINUTES
	                               MOV                MINUTES,AL
	                               MOV                AL,DISPLAYED_SECONDS
	                               MOV                SECONDS,AL
	;mov  al, seconds              	;;;divide if seconds two digit
	                               mov                bh,10
	                               mov                ah,00
	                               div                bh
	                               mov                temp_sec2,ah
	                               mov                temp_sec1,al

	;;;;;;;;;;;;;;;;;;;;;;;;print minute;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	                               mov                dl,22h
	                               mov                dh,1h                           	;row
	                               mov                bh,0
	                               mov                ah,02h
	                               int                10h
	                               mov                bl,1                            	;color
	                               mov                al,minutes
	                               add                al,30h
	                               mov                ah,0eh                          	;
	                               int                10h

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;print colon;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;print colon;;;;;


	                               mov                dl,23h                          	;column
	                               mov                ah,02h
	                               int                10h
	                               mov                al,3ah
	                               mov                ah,0eh                          	;
	                               int                10h
	;;;;;;;;;;;;;;;;;;;;;;;;print second;;;;;;;;;;;;;;;;;;;;;;;
	                               mov                dl,24h                          	;column
	                               mov                ah,02h
	                               int                10h
	                               mov                al, temp_sec1
	                               add                al,30h
	                               mov                ah,0eh                          	;
	                               int                10h
	;;;;;;;;;;;;;;;;;;;;;;;second digit;;;;;;;;;;;;;;;;;;;;;;;;;;
	                               mov                dl,25h                          	;column
	                               mov                ah,02h
	                               int                10h
	                               mov                al,temp_sec2
	                               add                al,30h
	                               mov                ah,0eh                          	;
			
	                               int                10h


	                               JMP                END_PRINT_TIME_PROC

	TIME_OUT:                      
	                               MOV                END_OF_THE_GAME,2

	END_PRINT_TIME_PROC:           

	                               RET
Print_time ENDP




print_score_player1 proc  near

	;;;;;;;;;;;;;;;;;;;;;;;;;;clear last position

	                               mov                cx,4
	                               mov                dx,014fh
	clear_digits2:                 mov                bh,0
	                               mov                ah,02h
	                               int                10h
    
	;score of player 2
	                               mov                bl,0                            	;color
	                               mov                al,0
	                               add                al,30h
	                               mov                ah,0eh                          	;
			
	                               int                10h
	                               dec                dx
	                               loop               clear_digits2
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	                               PUSH               PLAYER1_SCORE
	                               mov                ax,  PLAYER1_SCORE
	                               mov                temp_to_reset_score2,ax
	NEXT_DIGIT_2:                  mov                ax, PLAYER1_SCORE
	                               add                temp_to_addation ,1
	                               mov                bx,10
	                               mov                dx,0
	                               div                bx
	                               mov                PLAYER1_SCORE,ax
	                               mov                temp2_score,dx
	                               mov                dl,4fh                          	;column
					
	                               sub                dl,temp_to_addation

	                               mov                dh,1h                           	;row
	                               mov                bh,0
	                               mov                ah,02h
	                               int                10h
    
	;score of player 2
	                               mov                bl,4                            	;color
	                               mov                al,byte ptr temp2_score
	                               add                al,30h
	                               mov                ah,0eh                          	;
			 
	                               int                10h
	                               mov                ax,PLAYER1_SCORE
	                               cmp                ax,0
	                               jg                 NEXT_DIGIT_2

	                               mov                ax,temp_to_reset_score2
	                               mov                PLAYER1_SCORE,ax
	                               mov                al,0
	                               mov                temp_to_addation ,al
	                               pop                PLAYER1_SCORE
	                               ret
	
print_score_player1 ENDP
DRAW_STATUS_BAR PROC NEAR


	                               mov                ah, 2ch
	                               int                21h                             	;RETURN SECONDS IN DH
	                               MOV                LAST_SYS_SECOND,DH
	                               MOV                AL , TIME
	                               SUB                AL,1
	                               MOV                DISPLAYED_MINUTES,AL
	                               MOV                MINUTES,AL
	                               MOV                AL,DISPLAYED_SECONDS
	                               MOV                SECONDS,AL
	                               CALL               Print_time



	                               CMP                player_num ,2
	                               JNE                YES_NO_NEED_TO_XCHG_THEM_AGAIN
	                               CMP                NAME_XCHGED_BEFORE,1
	                               JZ                 YES_NO_NEED_TO_XCHG_THEM_AGAIN
						
	                               mov                bx, 0
	                               mov                cx , 15

	_lop_:                         
	                               mov                ah , [name_s+bx]
	                               mov                al,[name_s2+bx]
	                               mov                [name_s+bx],al
mov[name_s2+bx],ah
	                               inc                bx
	                               loop               _lop_
				
	                               mov                NAME_XCHGED_BEFORE,1
	YES_NO_NEED_TO_XCHG_THEM_AGAIN:
	;;;;;;;;;;;;print name 1
	                               mov                si,offset name_s+4
	
	                               mov                dx,013bh
	en:                            mov                ah,2
	                               int                10h

	                               mov                ah,09
	                               mov                bh,0
	                               mov                al,[si]
	                               mov                cx,1h
	                               mov                bl,2

	                               int                10h

	;
	                               inc                dx
	                               inc                si
	                          
	                               mov                bx,si
	                               inc                si
	                               mov                al,[si]
	                               cmp                al,'$'
	                               mov                si,bx
	                               jnz                en

 


	;;;;;;;;;;;;;;;;;;





 




	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	;;;;;;;;;;;;print name 2
	                               mov                si,offset name_s2+4
	
	                               mov                dx, 0102h
	loopname2:                     mov                ah,2
	                               int                10h

	                               mov                ah,09
	                               mov                bh,0
	                               mov                al,[si]
	                               mov                cx,1h
	                               mov                bl,5

	                               int                10h

	                               inc                dx
	                               inc                si
	                          
	                               mov                bx,si
	                               inc                si
	                               mov                al,[si]
	                               cmp                al,'$'
	                               mov                si,bx
	                               jnz                loopname2


	                               RET

DRAW_STATUS_BAR ENDP
ASK_FOR_LVL proc near
	                               mov                ax,0600h
	                               mov                cx,0
	                               mov                dx,184fh
	                               int                10h
	;text mode
	                               mov                ax,3
	                               int                10h

	                               mov                ah,2
	                               mov                dx,0800h
	                               int                10h

	                               mov                ah,09
	                               mov                dx ,offset DETERMINE_LVL
	                               int                21h


	;    mov  dx,0c00h
	;    int  10h

	                               mov                ah,09
	                               mov                dx ,offset give_option_FOR_LEVEL
	                               int                21h
	;;;;;;;;;;;;;;;;;;;;;;Enter number;;;;;;;;;;;;;;;;;;;;;;;

	ent2:                          mov                ah,1
	                               int                21h
	                               cmp                al,31h
	                               jz                 cont2
	                               cmp                al,32h
	                               jz                 cont2
	                               jnz                ent2

	cont2:                         sub                al,30h
	                               mov                LVL,al

	;;;;;;;;;;;;;;;;;;ask to press enter

	                               mov                ah,2
	                               mov                dx,0e00h
	                               int                10h

	                               mov                ah,09
	                               mov                dx,offset pressenterkey
	                               int                21h
	;wait for press key
	label22:                       mov                ah,0
	                               int                16h
	                               cmp                ah,28
	                               jnz                label22

	                               ret

ASK_FOR_LVL endp

ask_for_time proc near
	                               mov                ax,0600h
	                               mov                cx,0
	                               mov                dx,184fh
	                               int                10h
	;text mode
	                               mov                ax,3
	                               int                10h

	                               mov                ah,2
	                               mov                dx,0800h
	                               int                10h

	                               mov                ah,09
	                               mov                dx ,offset determine_time
	                               int                21h


	;    mov  dx,0c00h
	;    int  10h

	                               mov                ah,09
	                               mov                dx ,offset give_option
	                               int                21h
	;;;;;;;;;;;;;;;;;;;;;;Enter number;;;;;;;;;;;;;;;;;;;;;;;

	ent:                           mov                ah,1
	                               int                21h
	                               cmp                al,31h
	                               jz                 cont
	                               cmp                al,33h
	                               jz                 cont
	                               jnz                ent
	cont:                          sub                al,30h
	                               mov                time,al

	;;;;;;;;;;;;;;;;;;ask to press enter

	                               mov                ah,2
	                               mov                dx,0e00h
	                               int                10h

	                               mov                ah,09
	                               mov                dx,offset pressenterkey
	                               int                21h
	;wait for press key
	label2:                        mov                ah,0
	                               int                16h
	                               cmp                ah,28
	                               jnz                label2

	                               ret

ask_for_time endp



BEFORE_START_SETUP PROC NEAR



        ; MOV                AL,02H
	    ;                 MOV                AH,4FH
	    ;                 MOV                Bx,0100H
	    ;                 INT                10H
	;clean screen
	                               mov                bh,0
	                               mov                ax,0600h
	                               mov                cx,0
	                               mov                dx,184fh
	                               int                10h
	; text mode
	                               MOV                AL,0
	                               mov                ax,3
	                               int                10h
	                               mov                ah,2
	                               mov                dx,081fh
	                               int                10h

	                               mov                ah,09
	                               mov                dx ,offset ask_name
	                               int                21h
	v_c2:                          mov                ah,2
	                               mov                dx,0a1fh
	                               int                10h
	                               mov                ah,0ah
	                               mov                dx,offset name_s+2
	                               int                21h
	                             
	                 




	
	                               mov                dl,name_s+4
	                               cmp                dl,41H
	                               jl                 v_c2
	                               cmp                dl,7ah
	                               jg                 v_c2
	                               cmp                dl,5ah
	                               jg                 chek_a2
	                               jle                continue_in2
	                    
	chek_a2:                       
	                               cmp                dl,61H
	                               jl                 v_c2
	                 
	;;;;;;;


	;set curser
	continue_in2:                  mov                ah,2
	                               mov                dx,0c1fh
	                               int                10h
	;out put of press any key to continue
	                               mov                ah,09
	                               mov                dx,offset pressenterkey
	                               int                21h
	;wait for press key
	
	label1:                        mov                ah,0
	                               int                16h
	                               cmp                ah,28
	                               jnz                label1




;come here directly in 2nd game 
	;to clean screen
	go_to_menu:                    mov                ax,0600h
	                               mov                cx,0
	                               mov                dx,184fh
	                               int                10h

	;text mode
	                               mov                ax,3
	                               int                10h


	                               mov                ah,2
	                               mov                dx,0800h
	                               int                10h
	;input in page 2
	                               mov                ah,09
	                               mov                dx,offset message
	                               int                21h
								   
	                               call               take_name
	; to make zero flag not equal zero
	                               add                ah,2
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;invitation


; mov ah,9
; mov al,'-'
; mov bh,0
; mov bl,7
; mov cx,80
; int 10h



	




	                               mov                value , 0
	inv1:                          receive1
	                               cmp                value , 1
	                               jz                 leave_now
	                               cmp                value , 59
	                               jz                 rec_chat_inv
	                               cmp                value , 60
	                               jz                 rec_game_inv
	                               mov                ah,1
	                               int                16h
	                               jz                 inv1
	                               mov                ah, 0

	                               int                16h
	                               cmp                ah , 1
	                               jz                 send_then_leave
	                               cmp                ah , 60
	                               jz                 send_game_inv
	                               cmp                ah , 59
	                               jz                 send_chat_inv
	                               jmp                inv1




	;if char send i'm player 1
	; else receive
	rec_chat_inv:                  
	                               mov                player_num , 2
	;display 3ndy ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"receive chat invitaion";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	             
				                   move_cursor 0,20
                                   print_msg line 
	                               move_cursor        1,23
	                               print_msg          rec_chat_inv_msg
	                               mov                ah , 0
	                               int                16h
	                               cmp                ah , 1
	                               jz                 send_then_leave
	                               cmp                ah, 59
	                               jz                 accept_chat
	                               cmp                ah , 60
	                               jz                 send_game_inv
	                               jmp                rec_chat_inv
	


	send_game_inv:                 
	                               mov                player_num , 1
	                               mov                value , 60
	                               send
	                               mov                value , 0
								    move_cursor 0,20
                                   print_msg line 
	                               move_cursor        1,23
	                               print_msg          send_game_inv_msg
					
	;display 3ndy ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"I'm send game inv" ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	                               mov                value , 0
	                               receive
	                               cmp                value , 1
	                               jz                 leave_now
	                               cmp                value , 60
	                               jz                 startgame
	                               cmp                value , 59
	                               jz                 rec_chat_inv
	                               jmp                send_game_inv
	




	
	send_chat_inv:                 
	                               mov                player_num , 1
	                               mov                value , 59
	                               send
	                               mov                value , 0
								    move_cursor 0,20
                                   print_msg line 
	                               move_cursor        1,23
	                               print_msg          send_chat_inv_msg
	;display 3ndy ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"I'm send chat inv" ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	                               mov                value , 0
	                               receive
	                               cmp                value , 1
	                               jz                 leave_now
	                               cmp                value , 59
	                               jz                 chatting
	                               cmp                value , 60
	                               jz                 rec_game_inv
	                               jmp                send_chat_inv







	rec_game_inv:                  
	                                move_cursor 0,20
                                   print_msg line 
	                               move_cursor        1,23
	                               print_msg          rec_game_inv_msg
	                               mov                player_num , 2
	;display 3ndy ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"receive game invitaion";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	                               mov                ah , 0
	                               int                16h
	                               cmp                ah , 1
	                               jz                 send_then_leave
	                               cmp                ah, 60
	                               jz                 accept_game
	                               cmp                ah , 59
	                               jz                 send_chat_inv
	                               jmp                rec_game_inv

	accept_chat:                   
	                               mov                value , 59
	                               send
	                               jmp                chatting

	accept_game:                   
	                               mov                value , 60
	                               send
	                               jmp                startgame




	;wait for prees key
	; return:             mov                ah,0
	;                     int                16h

	;                     cmp                ah,59
	;                     jz                 Chatting

	                   

	;                     cmp                ah,60
	;                     jz                 startGame
							  
 
	;                     jnz                return



	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;for chatting not complete

	chatting:                      
	

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	                               call               chat1

	                               jmp                go_to_menu

	; mov  ah,0
	; int  16h
						

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
						
						
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	                               jmp                startGame
	send_then_leave:               
	                               mov                value , Ah
	                               send
leave_now:
.Exit
	startGame:                  
              
			  
	                            RET
BEFORE_START_SETUP ENDP
take_name proc near

	; ;set divisor
	                             

	;                             mov                si, offset name_s+2
	;                             mov                di,offset name_s2+2
	;                             mov                dx,3fbh                                               	; Line Control Register
	;                             mov                al,10000000b                                          	;Set Divisor Latch Access Bit
	;                             out                dx,al
	; ;set lsb
	;                             mov                dx,3f8h
	;                             mov                al,0ch
	;                             out                dx,al
	;                             mov                dx,3f9h
	;                             mov                al,00h
	;                             out                dx,al
	; ;set port
	;                             mov                dx,3fbh
	;                             mov                al,00011011b
	;                             out                dx,al
	; ;;;;;;;;;sending
	; ;;;;;;;;set cursor
	
	; ;  mov  ah,0
	; ; int  16h

								


	; ll:                         mov                dx , 3FDH                                             	; Line Status Register
	; AGAIN4:                     In                 al , dx                                               	;Read Line Status
	;                             test               al , 00100000b
	;                             JZ                 AGAIN4


	;                             mov                dx , 3F8H                                             	; Transmit data register
	;                             mov                al,[si]
	;                             out                dx , al
	; ;;;;;;;;;;if press key
	
	                            
	; ; cmp al,1bh ;ESC key
	; ; jz exit2
	; ;;;;;;;;;;;;;;printing
	                              
	; ;int 21h
	; ;;;;;;;;;;;;

	; ;;;;;;;;;;;;;;;;;
	; ;   Check that Data is Ready
	;                             mov                dx , 3FDH                                             	; Line Status Register
	; CHK4:                       in                 al , dx
	;                             test               al , 1
	;                             JZ                 CHK4                                                  	;Not Ready
	; ;If Ready read the VALUE in Receive data register
	;                             mov                dx , 03F8H
	;                             in                 al , dx
	;                             mov                [di] , al
	;                             inc                si
	;                             inc                di
	;                             cmp                name_s[si],'$'
	;                             jne                ll

	; exit4:
	
	;                             ret
	                            mov     si, offset name_s+2
	                            mov     di,offset name_s2+2
	;                             mov                dx,3fbh                                               	; Line Control Register
	;                             mov                al,10000000b                                          	;Set Divisor Latch Access Bit
	;                             out                dx,al
	; ;set lsb
	;                             mov                dx,3f8h
	;                             mov                al,0ch
	;                             out                dx,al
	;                             mov                dx,3f9h
	;                             mov                al,00h
	;                             out                dx,al
	; ;set port
	;                             mov                dx,3fbh
	;                             mov                al,00011011b
	;                             out                dx,al
	;;;;;;;;;sending
	;;;;;;;;set cursor
	
	;  mov  ah,0
	; int  16h

								

	                            mov     cx , 15
	ll:                         mov     dx , 3FDH                                             	; Line Status Register
	AGAIN4:                     In      al , dx                                               	;Read Line Status
	                            test    al , 00100000b
	                            JZ      AGAIN4


	                            mov     dx , 3F8H                                             	; Transmit data register
	                            mov     al,[si]
	                            out     dx , al
	;;;;;;;;;;if press key
	
	                            
	; cmp al,1bh ;ESC key
	; jz exit2
	;;;;;;;;;;;;;;printing
	                              
	;int 21h
	;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;
	;   Check that Data is Ready
	                            mov     dx , 3FDH                                             	; Line Status Register
	CHK4:                       in      al , dx
	                            test    al , 1
	                            JZ      CHK4                                                  	;Not Ready
	;If Ready read the VALUE in Receive data register
	                            mov     dx , 03F8H
	                            in      al , dx
	                            mov     [di] , al
	                            inc     di
								
	                            inc     si
	; cmp                name_s[si],'$'
	;jne                ll
	                            loop    LL

	exit4:                      
	
	                            ret


take_name endp


chat1 proc near



	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;start of chat;;;;;;;;;;;;;;;;;

	;to clean screen
	
	                             mov     ax,0600h
	                             mov     cx,0
	                             mov     dx,184fh
	                             int     10h
	;text mode
	                             mov     ax,3
	                             int     10h


	                             mov     ah,2
	                             mov     dx,0000h
	                             int     10h
	                             mov     ah,09
	                             mov     dx,offset chat
	; int  21h
	;;;;;;;;;;;;;clean screen;;;;;;;;;;
						
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	                             mov     cx,4fh
	                  

	lo:                          mov     ah,2
	                             mov     dx,0b00h
	                             add     dx,cx
	                             int     10h
	                             mov     ah,2h
					

	                             mov     dl,'_'
	                             int     21h
	                             loop    lo

	                 
	                             mov     ah,2
	                             mov     dx,0000h
	                             int     10h
	;;;;;;;;;;;;;;;;;print name of first player;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	                             mov     ah,09
	                             mov     dx,offset name_s+4
	                             int     21h
	;;;;;;;;;;;print second name;;;;;;
	                             mov     ah,2
	                             mov     dx,0d00h
	                             int     10h
	                             mov     ah,09
	                             mov     dx,offset name_s2+4
	                             int     21h
	                           
	
	                             mov     chat_countre_send,00h
	                             mov     inc_dh,02h
	;   mov                dx,0f00h
	                             mov     chat_countre_recieve,00h
	                             mov     inc_dh2,0fh


	inf:                         


	;;;;;;;;;;if press key
	                             mov     ah,1
	                             int     16h
	                             jz      re
	                             mov     ah,0
	                             int     16h
	; cmp al,1bh ;ESC key
	; jz exit2
	;;;;;;;;;;;;;;printing

	                             mov     ah,2
	                             mov     dl,al
	                             mov     VALUE,al
	                             cmp     VALUE,1bh

	                             jnz     continue_without_exit
							

	                             mov     ah,-15
	                             mov     value,ah
	                             send
	                             jmp     exit_chat
 
  
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	continue_without_exit:       cmp     inc_dh,0ah
	                             jz      check_x

	                             jnz     con_chat_check
	check_x:                                                                                   	;;;;;;;;;;;;;;;;;to check end of line
	                             cmp     chat_countre_send,4fh
	                             jnz     con_chat_check

	;;;;;;;;;;;;;;;;;;;;;;;;;scrolling

	                             mov     ah,00
	                             mov     chat_countre_send,ah
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	                             mov     ah,6                                                  	; function 6
	                             mov     al,1                                                  	; scroll by 1 line
	                             mov     bh,7                                                  	; normal video attribute
	                             mov     ch,02                                                 	; upper left Y
	                             mov     cl,00                                                 	; upper left X
	                             mov     dh,0ah                                                	; lower right Y
	                             mov     dl,4fh                                                	; lower right X
	                             int     10h

	                             jmp     co1



	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	
	con_chat_check:              
	; cmp     value,1bh
	;jz      exit_chat
	;  jz                 exit2
	;int 21h
	;;;;;;;;;;;;

	                             cmp     chat_countre_send,4fh
	                             je      rest
	                             jne     co




	                          

	rest:                        

	                             mov     ah,00
	                             mov     chat_countre_send,ah
	                             inc     inc_dh


	co:                          
	                        
	                        

	co1:                         mov     ah,2
	                             mov     bh , 0
	;   mov  dx,0100h
	                             mov     dl,chat_countre_send
	                             mov     dh,inc_dh
								  
	                             int     10h



	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;back_space;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	                             cmp     value,8h
	                             jnz     not_backspace
	                             mov     ah,20H
	                             mov     value,ah
	                             dec     dx


	                             mov     ah,2
	                             mov     bh , 0
	
	                             int     10h
	                             dec     dx
	                             mov     chat_countre_send,dl
	                             mov     inc_dh,dh
	                             mov     check_backspace,18


	;;;;;;;;;;;;;;;;;
	                         
	not_backspace:               mov     ah,09
	                             mov     bh,0
	                             mov     al,value
	                             mov     cx,1h
	                             mov     bl,5

	                             int     10h
	                             inc     chat_countre_send
	                             cmp     check_backspace,18
	                             jnz     cont_chat_this_not_backspace
	                             mov     value,-20
	                             mov     ah,0
	                             mov     check_backspace,ah
								 
	;;;;;;;;;;;;;;;;;;;;;;;;
	cont_chat_this_not_backspace:mov     dx , 3FDH
	; Line Status Register
	AGAIN:                       In      al , dx                                               	;Read Line Status
	                             test    al , 00100000b
	                             JZ      AGAIN
	                          
	;If empty put the VALUE in Transmit data register
	                             mov     dx , 3F8H                                             	; Transmit data register
	                             mov     al,VALUE
	                             out     dx , al
	;;;;;;;;;;;;;;;;;;;transmit
	;;;;;;;set cursor





	;;;;;;;;;;;;;;;;;;;
	re:                          

	;Check that Data is Ready
	                             mov     dx , 3FDH                                             	; Line Status Register
	                             in      al , dx
	                             test    al , 1
	                             JZ      CHK                                                   	;Not Ready
	;If Ready read the VALUE in Receive data register
	                             mov     dx , 03F8H
	                             in      al , dx
	                             mov     VALUE , al

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;scrolling
	                             cmp     inc_dh2,17h
	                             jz      check_x1
	                             jnz     con_chat_check2
	check_x1:                                                                                  	;;;;;;;;;;;;;;;;;to check end of line
	                             cmp     chat_countre_recieve,4fh
	                             jnz     con_chat_check2


	                           


	                             mov     ah,00
	                             mov     chat_countre_recieve,ah
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	                             mov     ah,6                                                  	; function 6
	                             mov     al,1                                                  	; scroll by 1 line
	                             mov     bh,7                                                  	; normal video attribute
	                             mov     ch,0fh                                                	; upper left Y
	                             mov     cl,00                                                 	; upper left X
	                             mov     dh,17h                                                	; lower right Y
	                             mov     dl,4fh                                                	; lower right X
	                             int     10h

	                             jmp     co2


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	con_chat_check2:             cmp     chat_countre_recieve,4fh
	                             je      rest2
	                             jne     co2

	rest2:                       
	                             mov     ah,00
	                             mov     chat_countre_recieve,ah
	                             inc     inc_dh2
	                          
 

	co2:                         
	                             mov     bh , 0

	;mov VALUE,al
	                             mov     ah,2
	                        
	; mov  dx,0f00h
	; add  dx,counter_chat2
	                             mov     dl,chat_countre_recieve
							
	                             mov     dh,inc_dh2
	                        

	                             int     10h
	;;;;;;;;;;;;;;;;;;;;;;;;;;;backspace;;;;;;;;;;;;
	                             cmp     value,-20
	                             jnz     not_backspace2
	                             mov     ah,20H
	                             mov     value,ah
	                             dec     dx
	;								 mov ah,0
	; mov check_backspace,ah


	                             mov     ah,2
	                             mov     bh , 0
	
	                             int     10h
	                             dec     dx
	                             mov     chat_countre_recieve,dl
	                             mov     inc_dh2,dh
								 
								

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	not_backspace2:              mov     ah,2
	                             mov     al , value
	                             mov     dl,al
							
	                         

	                             cmp     value,-15
	                             jz      exit_chat
	                           
	;int 21h
	                             mov     ah,09
	                             mov     bh,0
	                             mov     al,value
	                             mov     cx,1h
	                             mov     bl,3
	                           
	                             int     10h
	                             inc     chat_countre_recieve
	
	CHK:                         
	                             jmp     inf


	exit2:                       
	

	exit_chat:                   ret
chat1 endp



DRAW_HEAD proc  NEAR

	                            MOV     CX,TEMP_HEAD_X                                        	;set the initial column (X)
	                            MOV     DX,TEMP_HEAD_Y                                        	;set the initial line (Y)
	                            MOV     SI , TEMPHEAD
	                            SUB     CX,15                                                 	; BASED ON THAT THE SIZE OF THE SQUARE IS 31
	                            SUB     DX,15
	                            MOV     TEMP_HEAD_TRAN_X,CX
	                            MOV     TEMP_HEAD_TRAN_Y,DX
	
	DRAW_HEAD_LABEL:            
	;set the configuration to writing a pixel
	                            MOV     AH,0Ch                                                	;set the configuration to writing a pixel
	                            MOV     AL,[SI]                                               	;choose CORRECT color
	                            MOV     BH,00h                                                	;set the page number
	                            INT     10h                                                   	;execute the configuration
			
	                            INC     SI                                                    	; GET THE NEXT COLOR

	                            INC     CX                                                    	;CX = CX + 1
	                            MOV     AX,CX                                                 	;CX - BALL_X > BALL_SIZE (Y -> We go to the next line,N -> We continue to the next column
	                            SUB     AX,TEMP_HEAD_TRAN_X
	                            CMP     AX,SQUARE_SIZE
	                            JNE     DRAW_HEAD_LABEL
			
	                            MOV     CX,TEMP_HEAD_TRAN_X                                   	;the CX register goes back to the initial column
	                            INC     DX                                                    	;we advance one line
			
	                            MOV     AX,DX                                                 	;DX - BALL_Y > BALL_SIZE (Y -> we exit this procedure,N -> we continue to the next line
	                            SUB     AX,TEMP_HEAD_TRAN_Y
	                            CMP     AX,SQUARE_SIZE
	                            JNE     DRAW_HEAD_LABEL
	                            RET
DRAW_HEAD ENDP

DRAW_BODY PROC NEAR

	                            MOV     CX,INIT_SQUARE_X                                      	;set the initial column (X)
	                            MOV     DX,INIT_SQUARE_Y
	                            MOV     SI , TEMP_BODY_SHAPE                                  	;set the initial line (Y)
	                            SUB     CX,15
	                            SUB     DX,15
	                            MOV     INIT_SQUARE_TRAN_X,CX
	                            MOV     INIT_SQUARE_TRAN_Y,DX
	
	DRAW_BODY_HORIZONTALL:      
	                            MOV     AH,0Ch                                                	;set the configuration to writing a pixel
	                            MOV     AL,[SI]
	                            MOV     AH,0Ch                                                	;choose CORRECT color
	                            MOV     BH,00h                                                	;set the page number
	                            INT     10h                                                   	;execute the configuration
			
	                            INC     SI                                                    	; GET THE NEXT COLOR

	                            INC     CX                                                    	;CX = CX + 1
	                            MOV     AX,CX                                                 	;CX - BALL_X > BALL_SIZE (Y -> We go to the next line,N -> We continue to the next column
	                            SUB     AX,INIT_SQUARE_TRAN_X
	                            CMP     AX,SQUARE_SIZE
	                            JNE     DRAW_BODY_HORIZONTALL
			
	                            MOV     CX,INIT_SQUARE_TRAN_X                                 	;the CX register goes back to the initial column
	                            INC     DX                                                    	;we advance one line
			
	                            MOV     AX,DX                                                 	;DX - BALL_Y > BALL_SIZE (Y -> we exit this procedure,N -> we continue to the next line
	                            SUB     AX,INIT_SQUARE_TRAN_Y
	                            CMP     AX,SQUARE_SIZE
	                            JNE     DRAW_BODY_HORIZONTALL
							
	                            RET
DRAW_BODY ENDP

DRAW_APPLE PROC NEAR

	;;;;;;;;;;;;;;;;VALIDATION
								
	                            MOV     AX,APPLES_NUM
	                            MOV     BX,2
	                            MUL     BX
	                            SUB     AX,4                                                  	; TRIVIAL NUMBER => STOP BEFORE END
	                            CMP     CURR_APPLE_INDEX,AX
	                            JB      NOT_END_OF_APPLES_ARR
	                            MOV     CURR_APPLE_INDEX,0
	NOT_END_OF_APPLES_ARR:      
	                            MOV     SI,OFFSET APPLE_X
	                            MOV     BX, CURR_APPLE_INDEX
	                            MOV     DX, [SI+BX]
	                            MOV     TEMP_HEAD_X ,DX

	                            MOV     SI,OFFSET APPLE_Y
	                            MOV     BX, CURR_APPLE_INDEX
	                            MOV     DX, [SI+BX]
	                            MOV     TEMP_HEAD_Y ,DX

	                            CMP     NUM_TO_GET_GOLDEN,5
	                            JNE     NOT_GOLDEN
	;MOV NUM_TO_GET_GOLDEN,0
	                            MOV     APPLE_TYPE,1
	                            MOV     TEMPHEAD,OFFSET GOLDEN_APPLE
	                            CALL    DRAW_HEAD

	                            RET

	NOT_GOLDEN:                 
	                            MOV     APPLE_TYPE,0
	                            MOV     TEMPHEAD, OFFSET APPLE
	                            CALL    DRAW_HEAD

	                            RET
DRAW_APPLE ENDP



DRAW_FIRE PROC NEAR

	;;;;;;;;;;;;;;;;VALIDATION

	                            MOV     AX,FIRES_NUM
	                            MOV     BX,2
	                            MUL     BX
	                            SUB     AX,4                                                  	; TRIVIAL NUMBER => STOP BEFORE END
	                            CMP     CURR_FIRE_INDEX,AX
	                            JB      NOT_END_OF_FIRES_ARR
	                            MOV     CURR_FIRE_INDEX,0
	NOT_END_OF_FIRES_ARR:       
	                            MOV     SI,OFFSET FIRE_X
	                            MOV     BX, CURR_FIRE_INDEX
	                            MOV     DX, [SI+BX]
	                            MOV     TEMP_HEAD_X ,DX

	                            MOV     SI,OFFSET FIRE_Y
	                            MOV     BX, CURR_FIRE_INDEX
	                            MOV     DX, [SI+BX]
	                            MOV     TEMP_HEAD_Y ,DX
			 
	                            MOV     TEMPHEAD, OFFSET FIRE
	                            CALL    DRAW_HEAD

	                            RET
DRAW_FIRE ENDP

DRAW_BACK_G PROC NEAR                                                                     		; GIVE IT INITIAL_SQUARE_X, AND INITIAL_SQUARE_Y AND TEMP_COLOR

	



	;   MOV  CX,INIT_SQUARE_X                       	;set the initial column (X)
	;   MOV  DX,INIT_SQUARE_Y
	                                   
	;   SUB  CX,15
	;   SUB  DX,15
	                            MOV     INIT_SQUARE_TRAN_X,0
	                            MOV     INIT_SQUARE_TRAN_Y,50
	                            MOV     CX ,  INIT_SQUARE_TRAN_X
	                            MOV     DX ,INIT_SQUARE_TRAN_Y
	DRAW_BACK_HORIZONTALL:      
	;set the configuration to writing a pixel
	                            MOV     AL,BGC
	                            MOV     AH,0Ch                                                	;choose CORRECT color
	                            MOV     BH,00h                                                	;set the page number
	                            INT     10h                                                   	;execute the configuration
			
	; GET THE NEXT COLOR
	                            INC     CX                                                    	;CX = CX + 1
	                            MOV     AX,CX                                                 	;CX - BALL_X > BALL_SIZE (Y -> We go to the next line,N -> We continue to the next column
	                            SUB     AX,INIT_SQUARE_TRAN_X
	                            CMP     AX,640
	                            JNE     DRAW_BACK_HORIZONTALL
			
	                            MOV     CX,INIT_SQUARE_TRAN_X                                 	;the CX register goes back to the initial column
	                            INC     DX                                                    	;we advance one line
			
	                            MOV     AX,DX                                                 	;DX - BALL_Y > BALL_SIZE (Y -> we exit this procedure,N -> we continue to the next line
	                            SUB     AX,INIT_SQUARE_TRAN_Y
	                            CMP     AX,400
	                            JNE     DRAW_BACK_HORIZONTALL
							
	                            MOV     DX,42
	                            PUSH    DX

	LES1:                       
	                            POP     DX                                                    	;set the initial column (X)
	                            ADD     DX , 24
	                            PUSH    DX
	                            MOV     CX,13
	                            MOV     TEMP_HEAD_X,CX                                        	;set the initial column (X)
	                            MOV     TEMP_HEAD_Y , DX                                      	;set the initial line (Y)
	                            MOV     TEMPHEAD , OFFSET EDGE
	                            MOV     SQUARE_SIZE,23
	                            CALL    DRAW_HEAD
	                            CMP     DX ,385                                               	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	                            JBE     LES1
	                           
	                            POP     DX




	                            MOV     DX,42
	                            PUSH    DX
	LES2:                       
	                            POP     DX                                                    	;set the initial column (X)
	                            ADD     DX , 24
	                            PUSH    DX
	                            MOV     CX,628
	                            MOV     TEMP_HEAD_X,CX                                        	;set the initial column (X)
	                            MOV     TEMP_HEAD_Y , DX                                      	;set the initial line (Y)
	                            MOV     TEMPHEAD , OFFSET EDGE
	                            MOV     SQUARE_SIZE,23
	                            CALL    DRAW_HEAD
	                            CMP     DX ,375
	                            JBE     LES2
	                            POP     DX

	                            MOV     CX,4
	                            PUSH    CX
	LES3:                       
	                            POP     CX                                                    	;set the initial column (X)
	                            ADD     CX , 24
	                            PUSH    CX
	                            MOV     DX,66
	                            MOV     TEMP_HEAD_X,CX                                        	;set the initial column (X)
	                            MOV     TEMP_HEAD_Y , DX                                      	;set the initial line (Y)
	                            MOV     TEMPHEAD , OFFSET EDGE
	                            MOV     SQUARE_SIZE,23
	                            CALL    DRAW_HEAD
	                            CMP     CX ,604
	                            JBE     LES3
	                            POP     CX

	                            MOV     CX,4
	                            PUSH    CX
	LES4:                       
	                            POP     CX                                                    	;set the initial column (X)
	                            ADD     CX , 24
	                            PUSH    CX
	                            MOV     DX,395                                                	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	                            MOV     TEMP_HEAD_X,CX                                        	;set the initial column (X)
	                            MOV     TEMP_HEAD_Y , DX                                      	;set the initial line (Y)
	                            MOV     TEMPHEAD , OFFSET EDGE
	                            MOV     SQUARE_SIZE,23
	                            CALL    DRAW_HEAD
	                            CMP     CX ,600
	                            JBE     LES4
	                            POP     CX

	                            MOV     SQUARE_SIZE,31
	                            RET
DRAW_BACK_G ENDP

DRAW_SQUARE PROC NEAR                                                                     		; GIVE IT INITIAL_SQUARE_X, AND INITIAL_SQUARE_Y AND TEMP_COLOR

	                            MOV     CX,INIT_SQUARE_X                                      	;set the initial column (X)
	                            MOV     DX,INIT_SQUARE_Y
	                                   
	                            SUB     CX,15
	                            SUB     DX,15
	                            MOV     INIT_SQUARE_TRAN_X,CX
	                            MOV     INIT_SQUARE_TRAN_Y,DX
	
	DRAW_SQUARE_HORIZONTALL:    
	;set the configuration to writing a pixel
	                            MOV     AL,TEMP_COLOR
	                            MOV     AH,0Ch                                                	;choose CORRECT color
	                            MOV     BH,00h                                                	;set the page number
	                            INT     10h                                                   	;execute the configuration
			
	; GET THE NEXT COLOR
	                            INC     CX                                                    	;CX = CX + 1
	                            MOV     AX,CX                                                 	;CX - BALL_X > BALL_SIZE (Y -> We go to the next line,N -> We continue to the next column
	                            SUB     AX,INIT_SQUARE_TRAN_X
	                            CMP     AX,SQUARE_SIZE
	                            JNE     DRAW_SQUARE_HORIZONTALL
			
	                            MOV     CX,INIT_SQUARE_TRAN_X                                 	;the CX register goes back to the initial column
	                            INC     DX                                                    	;we advance one line
			
	                            MOV     AX,DX                                                 	;DX - BALL_Y > BALL_SIZE (Y -> we exit this procedure,N -> we continue to the next line
	                            SUB     AX,INIT_SQUARE_TRAN_Y
	                            CMP     AX,SQUARE_SIZE
	                            JNE     DRAW_SQUARE_HORIZONTALL
							
	                            RET
DRAW_SQUARE ENDP

 
DRAW_INIT_SNAKE PROC NEAR
	                            MOV     SNAKE1_HEAD_OFFSETS[0] , OFFSET SNAKE1_HEADSHAPE_UP
	                            MOV     SNAKE1_HEAD_OFFSETS[2] , OFFSET SNAKE1_HEADSHAPE_DOWN
	                            MOV     SNAKE1_HEAD_OFFSETS[4] , OFFSET SNAKE1_HEADSHAPE_RIGHT
	                            MOV     SNAKE1_HEAD_OFFSETS[6] , OFFSET SNAKE1_HEADSHAPE_LEFT

	                            MOV     SNAKE2_HEAD_OFFSETS[0] , OFFSET SNAKE2_HEADSHAPE_UP
	                            MOV     SNAKE2_HEAD_OFFSETS[2] , OFFSET SNAKE2_HEADSHAPE_DOWN
	                            MOV     SNAKE2_HEAD_OFFSETS[4] , OFFSET SNAKE2_HEADSHAPE_RIGHT
	                            MOV     SNAKE2_HEAD_OFFSETS[6] , OFFSET SNAKE2_HEADSHAPE_LEFT
	                            MOV     TEMPHEAD, OFFSET SNAKE1_HEADSHAPE_UP
	                            MOV     DX,SNAKE1_X[0]
	                            MOV     TEMP_HEAD_X ,DX
	                            MOV     DX,SNAKE1_Y[0]
	                            MOV     TEMP_HEAD_Y ,DX                                       	; DRAW HEAD OF SNAKE
	                            CALL    DRAW_HEAD
							
	; DRAW THE BODY
	                            MOV     DX,OFFSET BODY_SHAPE1
	                            MOV     TEMP_BODY_SHAPE,DX                                    	; SET THE COLOR OF THE FIRST SNAKE
							
	                            MOV     DX,SNAKE1_X[0]
	                            MOV     SNAKE1_X[2],DX                                        	; 2*(N-1) = 2(2-1) = 2    N-> SECOND POSITION =2
	                            MOV     INIT_SQUARE_X,DX

	                            MOV     DX,SNAKE1_Y[0]
	                            ADD     DX,31
	                            MOV     SNAKE1_Y[2],DX
	                            MOV     INIT_SQUARE_Y,DX
	                            CALL    DRAW_BODY
								
	                          

	; SECOND SNAKE WILL BE ADDED
	                            MOV     TEMPHEAD, OFFSET SNAKE2_HEADSHAPE_UP
	                            MOV     DX,SNAKE2_X[0]
	                            MOV     TEMP_HEAD_X ,DX
	                            MOV     DX,SNAKE2_Y[0]
	                            MOV     TEMP_HEAD_Y ,DX                                       	; DRAW HEAD OF SNAKE
	                            CALL    DRAW_HEAD
							
	; DRAW THE BODY
	                            MOV     DX,OFFSET BODY_SHAPE2
	                            MOV     TEMP_BODY_SHAPE,DX                                    	; SET THE COLOR OF THE FIRST SNAKE
							
	                            MOV     DX,SNAKE2_X[0]
	                            MOV     SNAKE2_X[2],DX                                        	; 2*(N-1) = 2(2-1) = 2    N-> SECOND POSITION =2
	                            MOV     INIT_SQUARE_X,DX

	                            MOV     DX,SNAKE2_Y[0]
	                            ADD     DX,31
	                            MOV     SNAKE2_Y[2],DX
	                            MOV     INIT_SQUARE_Y,DX
	                            CALL    DRAW_BODY
	                            CALL    print_score_player1
	                            CALL    print_score_player2



	                            RET
DRAW_INIT_SNAKE ENDP

DELETE_END PROC NEAR

	                            MOV     DI,CHOSEN_SNAKE
	                            CMP     DI , 1
	                            JZ      SNAKE1
	                            JMP     SNAKE2
	FUNC:                       
	                            MOV     CX,INIT_SQUARE_X                                      	;set the initial column (X)
	                            MOV     DX,INIT_SQUARE_Y
	                                              	
	                            SUB     CX,15
	                            SUB     DX,15
	                            MOV     INIT_SQUARE_TRAN_X,CX
	                            MOV     INIT_SQUARE_TRAN_Y,DX
	
	DELETE_SQUARE_HORIZONTALL:  
	                            MOV     AH,0Ch                                                	;set the configuration to writing a pixel
	                            MOV     AL,BGC                                                	;BLACK_PIXEL                            	;choose CORRECT color
	                            MOV     BH,00h                                                	;set the page number
	                            INT     10h                                                   	;execute the configuration
			                                	

	                            INC     CX                                                    	;CX = CX + 1
	                            MOV     AX,CX                                                 	;CX - BALL_X > BALL_SIZE (Y -> We go to the next line,N -> We continue to the next column
	                            SUB     AX,INIT_SQUARE_TRAN_X
	                            CMP     AX,SQUARE_SIZE
	                            JNE     DELETE_SQUARE_HORIZONTALL
			
	                            MOV     CX,INIT_SQUARE_TRAN_X                                 	;the CX register goes back to the initial column
	                            INC     DX                                                    	;we advance one line
			
	                            MOV     AX,DX                                                 	;DX - BALL_Y > BALL_SIZE (Y -> we exit this procedure,N -> we continue to the next line
	                            SUB     AX,INIT_SQUARE_TRAN_Y
	                            CMP     AX,SQUARE_SIZE
	                            JNE     DELETE_SQUARE_HORIZONTALL
	                            RET
							
	SNAKE1:                     
	                            SUB     DI , 1
	                            MOV     AX , DI
	                            MOV     BX , 2
	                            MUL     BX
	                            MOV     DI,AX
	                            MOV     BX,SNAKE_LEN_ARR[DI]                                  	;;;;;;;2(1-1)
	                            SUB     BX,1
	                            MOV     AX , BX
	                            MOV     BX , 2
	                            MUL     BX
	                            MOV     BX , AX
	                            MOV     DX,SNAKE1_X[BX]
	                            MOV     INIT_SQUARE_X ,DX

	                            MOV     DX,SNAKE1_Y[BX]
	                            MOV     INIT_SQUARE_Y,DX
	                            JMP     FUNC

	SNAKE2:                     
	                            SUB     DI , 1
	                            MOV     AX , DI
	                            MOV     BX , 2
	                            MUL     BX
	                            MOV     DI,AX
	                            MOV     BX,SNAKE_LEN_ARR[DI]
	                            SUB     BX,1
	                            MOV     AX , BX
	                            MOV     BX , 2
	                            MUL     BX
	                            MOV     BX , AX
	                            MOV     DX,SNAKE2_X[BX]
	                            MOV     INIT_SQUARE_X ,DX

	                            MOV     DX,SNAKE2_Y[BX]
	                            MOV     INIT_SQUARE_Y,DX
	                            JMP     FUNC

DELETE_END ENDP

SHIFT_SNAKE PROC NEAR
	                            MOV     SI,CHOSEN_SNAKE
	                            SUB     SI , 1
	                            MOV     AX , SI
	                            MOV     BX , 2
	                            MUL     BX
	                            MOV     SI,AX
	                          
	                            CMP     CHOSEN_SNAKE,1
	                            JZ      SHIFT_SNAKE_ONE
							
	                            MOV     CX,SNAKE_LEN_ARR[SI]
	                            MOV     BX,CX
	                            MOV     DI,OFFSET SNAKE2_X
	                            MOV     SI,OFFSET SNAKE2_Y
	                            JMP     L1
	SHIFT_SNAKE_ONE:            
	                            MOV     CX,SNAKE_LEN_ARR[SI]
	                            MOV     BX,CX

	                            MOV     DI,OFFSET SNAKE1_X
	                            MOV     SI,OFFSET SNAKE1_Y
	L1:                         
	                            PUSH    BX
	                            SUB     BX , 1
	                            MOV     AX , BX
	                            MOV     BX , 2
	                            MUL     BX
	                            MOV     BX , AX
	                            MOV     DX,[DI+BX]
	                            MOV     [DI+BX+2],DX
	                            MOV     DX,[SI+BX]
	                            MOV     [SI+BX+2],DX
	                            POP     BX
	                            DEC     BX
	                            LOOP    L1
	                            RET
SHIFT_SNAKE ENDP

MOVE_SNAKE1_UP PROC NEAR
	                            MOV     SNAKE1_HEAD_DIRECTION,0
	                            CMP     SNAKE1_Y[0] ,106
	                            JBE     EXITUP1
	                            MOV     CHOSEN_SNAKE , 1
	                            CALL    DELETE_END

							  
	                            MOV     TEMPHEAD, OFFSET SNAKE1_HEADSHAPE_UP
	                            MOV     DX,SNAKE1_X[0]
	                            MOV     TEMP_HEAD_X ,DX
	                            MOV     DX,SNAKE1_Y[0]
	                         
	                            SUB     DX,31
 
						

	                       
	                            MOV     TEMP_HEAD_Y ,DX
	                            CALL    SHIFT_SNAKE
	                            MOV     DX,TEMP_HEAD_X
	                            MOV     SNAKE1_X[0],DX
	                            MOV     DX,TEMP_HEAD_Y
	                            MOV     SNAKE1_Y[0],DX
	                            CALL    DRAW_HEAD
	                            MOV     TEMP_BODY_SHAPE,OFFSET BODY_SHAPE1
	                            MOV     DX,SNAKE1_X[2]
	                            MOV     INIT_SQUARE_X,DX
	                            MOV     DX, SNAKE1_Y[2]
	                            MOV     INIT_SQUARE_Y,DX
	                            CALL    DRAW_BODY


	EXITUP1:                    
	                            RET
							
	

	                          
MOVE_SNAKE1_UP ENDP


MOVE_SNAKE1_DOWN PROC NEAR
	                            MOV     SNAKE1_HEAD_DIRECTION,1
	                            CMP     SNAKE1_Y[0] ,352
	                            JAE     EXIT_DOWN1
	                            MOV     CHOSEN_SNAKE , 1
	                            CALL    DELETE_END
	                            MOV     TEMPHEAD, OFFSET SNAKE1_HEADSHAPE_DOWN
	                            MOV     DX,SNAKE1_X[0]
	                            MOV     TEMP_HEAD_X ,DX
	                            MOV     DX,SNAKE1_Y[0]
	                            ADD     DX,31
	                          
	                            MOV     TEMP_HEAD_Y ,DX
	                            CALL    SHIFT_SNAKE
	                            MOV     DX,TEMP_HEAD_X
	                            MOV     SNAKE1_X[0],DX
	                            MOV     DX,TEMP_HEAD_Y
	                            MOV     SNAKE1_Y[0],DX
	                            CALL    DRAW_HEAD
	                            MOV     TEMP_BODY_SHAPE,OFFSET BODY_SHAPE1
	                            MOV     DX,SNAKE1_X[2]
	                            MOV     INIT_SQUARE_X,DX
	                            MOV     DX, SNAKE1_Y[2]
	                            MOV     INIT_SQUARE_Y,DX
	                            CALL    DRAW_BODY
	EXIT_DOWN1:                 
	                            RET

	               
	                         
	                         
MOVE_SNAKE1_DOWN ENDP


MOVE_SNAKE1_RIGHT PROC NEAR
	                            MOV     SNAKE1_HEAD_DIRECTION,2
	                            CMP     SNAKE1_X[0] , 572
	                            JA      EXIT_RIGHT1
	                            MOV     CHOSEN_SNAKE , 1
	                            CALL    DELETE_END
							
	                            MOV     TEMPHEAD, OFFSET SNAKE1_HEADSHAPE_RIGHT
	                            MOV     DX,SNAKE1_X[0]
	                            ADD     DX,31
	                          
	                            MOV     TEMP_HEAD_X ,DX
	                            MOV     DX,SNAKE1_Y[0]
	                            MOV     TEMP_HEAD_Y ,DX
	                            CALL    SHIFT_SNAKE
	                            MOV     DX,TEMP_HEAD_X
	                            MOV     SNAKE1_X[0],DX
	                            MOV     DX,TEMP_HEAD_Y
	                            MOV     SNAKE1_Y[0],DX
							
	                            CALL    DRAW_HEAD
							
	                            MOV     TEMP_BODY_SHAPE,OFFSET BODY_SHAPE1
	                            MOV     DX,SNAKE1_X[2]
	                            MOV     INIT_SQUARE_X,DX
	                            MOV     DX, SNAKE1_Y[2]
	                            MOV     INIT_SQUARE_Y,DX
	                            CALL    DRAW_BODY
	EXIT_RIGHT1:                
	                            RET

MOVE_SNAKE1_RIGHT ENDP


MOVE_SNAKE1_LEFT PROC NEAR
	                            MOV     SNAKE1_HEAD_DIRECTION,3
	                            CMP     SNAKE1_X[0],48
	                            JBE     EXIT_LEFT1
	                            MOV     CHOSEN_SNAKE , 1
	                            CALL    DELETE_END
						
	                            MOV     TEMPHEAD, OFFSET SNAKE1_HEADSHAPE_LEFT
	                            MOV     DX,SNAKE1_X[0]
	                            SUB     DX,31
	       
	                            MOV     TEMP_HEAD_X ,DX
	                            MOV     DX,SNAKE1_Y[0]
	                            MOV     TEMP_HEAD_Y ,DX
	                            CALL    SHIFT_SNAKE
	                            MOV     DX,TEMP_HEAD_X
	                            MOV     SNAKE1_X[0],DX
	                            MOV     DX,TEMP_HEAD_Y
	                            MOV     SNAKE1_Y[0],DX
							
	                            CALL    DRAW_HEAD
							
	                            MOV     TEMP_BODY_SHAPE,OFFSET BODY_SHAPE1
	                            MOV     DX,SNAKE1_X[2]
	                            MOV     INIT_SQUARE_X,DX
	                            MOV     DX, SNAKE1_Y[2]
	                            MOV     INIT_SQUARE_Y,DX
	                            CALL    DRAW_BODY
	EXIT_LEFT1:                 
	                            RET
	

MOVE_SNAKE1_LEFT ENDP


MOVE_SNAKE2_UP PROC NEAR
	                            MOV     SNAKE2_HEAD_DIRECTION,0
	                            MOV     CHOSEN_SNAKE , 2
	                            CMP     SNAKE2_Y[0] ,98
	                            JBE     EXITUP2
	                          
	                            CALL    DELETE_END
	                     
							  
	                            MOV     TEMPHEAD, OFFSET SNAKE2_HEADSHAPE_UP
	                            MOV     DX,SNAKE2_X[0]
	                            MOV     TEMP_HEAD_X ,DX
	                            MOV     DX,SNAKE2_Y[0]
	                         
	                            SUB     DX,31
 
						

	                       
	                            MOV     TEMP_HEAD_Y ,DX
	                            CALL    SHIFT_SNAKE
	                            MOV     DX,TEMP_HEAD_X
	                            MOV     SNAKE2_X[0],DX
	                            MOV     DX,TEMP_HEAD_Y
	                            MOV     SNAKE2_Y[0],DX
	                            CALL    DRAW_HEAD
	                            MOV     TEMP_BODY_SHAPE,OFFSET BODY_SHAPE2
	                            MOV     DX,SNAKE2_X[2]
	                            MOV     INIT_SQUARE_X,DX
	                            MOV     DX, SNAKE2_Y[2]
	                            MOV     INIT_SQUARE_Y,DX
	                            CALL    DRAW_BODY

	EXITUP2:                    
	                            RET
							
                          
MOVE_SNAKE2_UP ENDP


MOVE_SNAKE2_DOWN PROC NEAR
	                            MOV     SNAKE2_HEAD_DIRECTION,1
	                            MOV     CHOSEN_SNAKE , 2
	                            CMP     SNAKE2_Y[0] ,352
	                            JAE     EXIT_DOWN2
	                         
	                            CALL    DELETE_END
	                            MOV     TEMPHEAD, OFFSET SNAKE2_HEADSHAPE_DOWN
	                            MOV     DX,SNAKE2_X[0]
	                            MOV     TEMP_HEAD_X ,DX
	                            MOV     DX,SNAKE2_Y[0]
	                            ADD     DX,31
	                          
	                            MOV     TEMP_HEAD_Y ,DX
	                            CALL    SHIFT_SNAKE
	                            MOV     DX,TEMP_HEAD_X
	                            MOV     SNAKE2_X[0],DX
	                            MOV     DX,TEMP_HEAD_Y
	                            MOV     SNAKE2_Y[0],DX
	                            CALL    DRAW_HEAD
	                            MOV     TEMP_BODY_SHAPE,OFFSET BODY_SHAPE2
	                            MOV     DX,SNAKE2_X[2]
	                            MOV     INIT_SQUARE_X,DX
	                            MOV     DX, SNAKE2_Y[2]
	                            MOV     INIT_SQUARE_Y,DX
	                            CALL    DRAW_BODY
	EXIT_DOWN2:                 
	                            RET
                                           
MOVE_SNAKE2_DOWN ENDP



MOVE_SNAKE2_RIGHT PROC NEAR
	                            MOV     SNAKE2_HEAD_DIRECTION,2
	                            MOV     CHOSEN_SNAKE , 2
	                            CMP     SNAKE2_X[0] , 592
	                            JAE     EXIT_RIGHT2
	                          
	                            CALL    DELETE_END
							
	                            MOV     TEMPHEAD, OFFSET SNAKE2_HEADSHAPE_RIGHT
	                            MOV     DX,SNAKE2_X[0]
	                            ADD     DX,31
	                          
	                            MOV     TEMP_HEAD_X ,DX
	                            MOV     DX,SNAKE2_Y[0]
	                            MOV     TEMP_HEAD_Y ,DX
	                            CALL    SHIFT_SNAKE
	                            MOV     DX,TEMP_HEAD_X
	                            MOV     SNAKE2_X[0],DX
	                            MOV     DX,TEMP_HEAD_Y
	                            MOV     SNAKE2_Y[0],DX
							
	                            CALL    DRAW_HEAD
							
	                            MOV     TEMP_BODY_SHAPE,OFFSET BODY_SHAPE2
	                            MOV     DX,SNAKE2_X[2]
	                            MOV     INIT_SQUARE_X,DX
	                            MOV     DX, SNAKE2_Y[2]
	                            MOV     INIT_SQUARE_Y,DX
	                            CALL    DRAW_BODY
	EXIT_RIGHT2:                
	                            RET

MOVE_SNAKE2_RIGHT ENDP


MOVE_SNAKE2_LEFT PROC NEAR
	                            MOV     SNAKE2_HEAD_DIRECTION,3
	                            MOV     CHOSEN_SNAKE , 2
	                            CMP     SNAKE2_X[0],48
	                            JBE     EXIT_LEFT2
	                         
	                            CALL    DELETE_END
							
	                            MOV     TEMPHEAD, OFFSET SNAKE2_HEADSHAPE_LEFT
	                            MOV     DX,SNAKE2_X[0]
	                            SUB     DX,31
	       
	                            MOV     TEMP_HEAD_X ,DX
	                            MOV     DX,SNAKE2_Y[0]
	                            MOV     TEMP_HEAD_Y ,DX
	                            CALL    SHIFT_SNAKE
	                            MOV     DX,TEMP_HEAD_X
	                            MOV     SNAKE2_X[0],DX
	                            MOV     DX,TEMP_HEAD_Y
	                            MOV     SNAKE2_Y[0],DX
							
	                            CALL    DRAW_HEAD
							
	                            MOV     TEMP_BODY_SHAPE,OFFSET BODY_SHAPE2
	                            MOV     DX,SNAKE2_X[2]
	                            MOV     INIT_SQUARE_X,DX
	                            MOV     DX, SNAKE2_Y[2]
	                            MOV     INIT_SQUARE_Y,DX
	                            CALL    DRAW_BODY
	EXIT_LEFT2:                 
	                            RET
	

MOVE_SNAKE2_LEFT ENDP

INCREASE_LEN PROC NEAR                                                                    		; TAKES CHOSEN_SNAKE,
	                            CMP     CHOSEN_SNAKE,1
	                            JZ      CHOSEN_SNAKE_IS_1
	;    MOV  SI,OFFSET SNAKE2_X
	;    MOV  DI,OFFSET SNAKE2_Y
	                            MOV     DX,MAX_TOTAL_LEN
	                            ADD     PLAYER2_SCORE,5
	;========                      POWER UP 1
	                            CMP     NUM_C_EAT_SNAKE1 , 0
	                            JG      EQU_0_1
	                            JMP     NOT_EQU_0_1
	EQU_0_1:                    
	                            MOV     NUM_C_EAT_SNAKE1 , 0
	                            MOV     NUM_C_EAT_SNAKE2 , 0
	NOT_EQU_0_1:                
	                            ADD     NUM_C_EAT_SNAKE2 , 1
	;==========
	                            CMP     SNAKE_LEN_ARR[2],DX
	                            JE      MAX_LENN
	                            ADD     SNAKE_LEN_ARR[2],1

	                            MOV     AX, SNAKE_LEN_ARR[2]
	                            MOV     BX,2
	                            MUL     BX
	                            SUB     AX,2
	                            MOV     BX,AX
	                            MOV     CX,SNAKE2_X[BX-2]
	                            MOV     DX,SNAKE2_Y[BX-2]
	                            MOV     SNAKE2_X[BX],CX
	                            MOV     SNAKE2_Y[BX],DX
	                           
	MAX_LENN:                   
	                            JMP     END_OF_CHOOSING_THE_SNAKE
	CHOSEN_SNAKE_IS_1:          
	;    MOV  SI,OFFSET SNAKE1_X
	;    MOV  DI,OFFSET SNAKE1_Y
	                            MOV     DX,MAX_TOTAL_LEN
	                            ADD     PLAYER1_SCORE ,5
	;================
	                            CMP     NUM_C_EAT_SNAKE2 , 0
	                            JG      EQU_0_2
	                            JMP     NOT_EQU_0_2
	EQU_0_2:                    
	                            MOV     NUM_C_EAT_SNAKE1 , 0
	                            MOV     NUM_C_EAT_SNAKE2 , 0
	NOT_EQU_0_2:                
	                            ADD     NUM_C_EAT_SNAKE1 , 1
	;==============
	                            CMP     SNAKE_LEN_ARR[0],DX
	                            JE      MAX_LEN2
	                            ADD     SNAKE_LEN_ARR[0],1

	                            MOV     AX, SNAKE_LEN_ARR[0]
	                            MOV     BX,2
	                            MUL     BX
	                            SUB     AX,2
	                            MOV     BX,AX
	                            MOV     CX,SNAKE1_X[BX-2]
	                            MOV     DX,SNAKE1_Y[BX-2]
	                            MOV     SNAKE1_X[BX],CX
	                            MOV     SNAKE1_Y[BX],DX
	                           
	MAX_LEN2:                   
	END_OF_CHOOSING_THE_SNAKE:  
							
	                            RET
INCREASE_LEN ENDP


DECREASE_LEN PROC NEAR
	                            CMP     CHOSEN_SNAKE,1
	                            JZ      CHOSEN_SNAKEE_IS_1

	                            MOV     DX,MIN_TOTAL_LEN
	                            MOV     BX , 0
	                            CMP     PLAYER2_SCORE , BX
	                            JZ      NO_DEC2
	                            CLC
	                            MOV     BX,5
	                            SUB     PLAYER2_SCORE,BX
	NO_DEC2:                    
	                            CMP     SNAKE_LEN_ARR[2],DX
	                            JBE     MIN_LEN_L
	                            MOV     DX , 35
	                            CMP     PLAYER2_SCORE,DX
	                            JGE     MIN_LEN_L
	                            CALL    DELETE_END
	                            SUB     SNAKE_LEN_ARR[2],1
	                           
	MIN_LEN_L:                  
	                            JMP     END_OF_CHOOSING_THE_SNAKES
	CHOSEN_SNAKEE_IS_1:         
	                         
	                            MOV     DX,MIN_TOTAL_LEN
	                           
	                            MOV     BX , 0
	                            CMP     PLAYER1_SCORE , BX
	                            JZ      NO_DEC1
	                            CLC
	                            MOV     BX,5
	                            SUB     PLAYER1_SCORE,BX
	NO_DEC1:                    
	                            CMP     SNAKE_LEN_ARR[0],DX
	                            JBE     MIN_LEN2
	                            MOV     DX , 35
	                            CMP     PLAYER1_SCORE,DX
	                            JGE     MIN_LEN2
	                            CALL    DELETE_END
	                            SUB     SNAKE_LEN_ARR[0],1
	                           
	MIN_LEN2:                   
	END_OF_CHOOSING_THE_SNAKES: 
							
	                            RET
DECREASE_LEN ENDP
	;//////////////////////////////////////////////////////////////////////
CHECK_FIRE PROC NEAR
	                            MOV     BX,CURR_FIRE_INDEX
	                            MOV     AX, [FIRE_X+BX]                                       	;   AX will INITIALLY contain the x-cordiante of the apple
	                            MOV     BX,SNAKE1_X[0]                                        	;   BX will INITIALLY contain the x-cordiante of the head of snake 1

	                            CMP     BX,AX
	                            JNG     A_GE_B_FOR_X_CHECKING_F                               	; GE==GREATER EQUAL
	                            XCHG    AX,BX                                                 	; IF BX IS LARGER THAN AX SO XCHG THEM
	A_GE_B_FOR_X_CHECKING_F:    
	                            MOV     DX,CRITICAL_DIST
	                            SUB     AX,BX                                                 	; AX WILL CONTAIN THE REAL DISTANCE
	                            CMP     AX,DX                                                 	; COMPARE THE DISTANCE BETWEEN SNAKE1_HEAD_CENTER AND APPLE_X BY CRITICAL DISTANCE
	                            JG      END_OF_SNAKE1_FALSE_F                                 	; CONDITION IS FALSE , RET

	                            MOV     BX,CURR_FIRE_INDEX
	                            MOV     AX, [FIRE_Y+BX]                                       	;   AX will INITIALLY contain the x-cordiante of the apple
	                            MOV     BX,SNAKE1_Y[0]

	                            CMP     BX,AX
	                            JNG     A_GE_B_FOR_Y_CHECKING_F
	                            XCHG    AX,BX

	A_GE_B_FOR_Y_CHECKING_F:    
	                            MOV     DX,CRITICAL_DIST
	                            SUB     AX,BX                                                 	; AX WILL CONTAIN THE REAL DISTANCE
	                            CMP     AX,DX                                                 	; COMPARE THE DISTANCE BETWEEN SNAKE1_HEAD_CENTER AND APPLE_X BY CRITICAL DISTANCE
	                            JBE     END_OF_SNAKE1_TRUE_F                                  	; CONDITION IS TRUE

	                            JMP     END_OF_SNAKE1_FALSE_F

	END_OF_SNAKE1_TRUE_F:       
	                            MOV     DX , BGC                                              	; CONDITION IS TRUE
	                            MOV     TEMP_COLOR,BGC                                        	; PREPARING FOR DELETING THE APPLE
	                            MOV     BX,CURR_FIRE_INDEX
	                            MOV     DX,[FIRE_X+BX]
	                            MOV     INIT_SQUARE_X,DX
	                            MOV     DX,[FIRE_Y+BX]
	                            MOV     INIT_SQUARE_Y,DX
	                            CALL    DRAW_SQUARE
	                            ADD     CURR_FIRE_INDEX,2
	                            MOV     CHOSEN_SNAKE,1
	                            CALL    DECREASE_LEN

	                            JMP     ENDD_F


	END_OF_SNAKE1_FALSE_F:      
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;THE 2ND SNAKE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	                            MOV     BX,CURR_FIRE_INDEX
	                            MOV     AX, [FIRE_X+BX]                                       	;   AX will INITIALLY contain the x-cordiante of the apple
	                            MOV     BX,SNAKE2_X[0]                                        	;   BX will INITIALLY contain the x-cordiante of the head of snake 1

	                            CMP     BX,AX
	                            JNG     A_GE_B_FOR_X_CHECKING2_F                              	; GE==GREATER EQUAL
	                            XCHG    AX,BX                                                 	; IF BX IS LARGER THAN AX SO XCHG THEM
	A_GE_B_FOR_X_CHECKING2_F:   
	                            MOV     DX,CRITICAL_DIST
	                            SUB     AX,BX                                                 	; AX WILL CONTAIN THE REAL DISTANCE
	                            CMP     AX,DX                                                 	; COMPARE THE DISTANCE BETWEEN SNAKE1_HEAD_CENTER AND APPLE_X BY CRITICAL DISTANCE
	                            JG      ENDD_F                                                	; CONDITION IS FALSE , RET

	                            MOV     BX,CURR_FIRE_INDEX
	                            MOV     AX, [FIRE_Y+BX]                                       	;   AX will INITIALLY contain the x-cordiante of the apple
	                            MOV     BX,SNAKE2_Y[0]

	                            CMP     BX,AX
	                            JNG     A_GE_B_FOR_Y_CHECKING2_F
	                            XCHG    AX,BX

	A_GE_B_FOR_Y_CHECKING2_F:   
	                            MOV     DX,CRITICAL_DIST
	                            SUB     AX,BX                                                 	; AX WILL CONTAIN THE REAL DISTANCE
	                            CMP     AX,DX                                                 	; COMPARE THE DISTANCE BETWEEN SNAKE1_HEAD_CENTER AND APPLE_X BY CRITICAL DISTANCE
	                            JBE     END_OF_SNAKE2_TRUE2_F                                 	; CONDITION IS TRUE

	                            JMP     ENDD_F

	END_OF_SNAKE2_TRUE2_F:                                                                    	; CONDITION IS TRUE
	                            MOV     DX , BGC                                              	; CONDITION IS TRUE
	                            MOV     TEMP_COLOR,BGC                                        	; PREPARING FOR DELETING THE APPLE
	                            MOV     BX,CURR_FIRE_INDEX
	                            MOV     DX,[FIRE_X+BX]
	                            MOV     INIT_SQUARE_X,DX
	                            MOV     DX,[FIRE_Y+BX]
	                            MOV     INIT_SQUARE_Y,DX
	                            CALL    DRAW_SQUARE
	                            ADD     CURR_FIRE_INDEX,2
	                            MOV     CHOSEN_SNAKE,2
	                            CALL    DECREASE_LEN

	                            JMP     ENDD_F
							  
							
	ENDD_F:                     
	                            RET
CHECK_FIRE ENDP
DRAW_SNAKE1 PROC NEAR

	                            MOV     CX , SNAKE1_X[0]
	                            MOV     DX , SNAKE1_Y[0]
	                            MOV     TEMP_HEAD_X ,CX                                       	;set the initial column (X)
	                            MOV     TEMP_HEAD_Y ,DX
	                            MOV     AX, SNAKE1_HEAD_DIRECTION
	                            MOV     BX , 2
	                            MUL     BX
	                            MOV     BX , AX
	                            MOV     AX , SNAKE1_HEAD_OFFSETS[BX]                          	;set the initial line (Y)
	                            MOV     TEMPHEAD , AX
	                            CALL    DRAW_HEAD
	                            MOV     CX , SNAKE_LEN_ARR[0]
	                            SUB     CX , 1
	                            MOV     BX , 2
	                            CMP SNAKE1_FREEZE ,0
								JG MOVE_FREEZED_BODY1
	                            MOV     TEMPHEAD , OFFSET BODY_SHAPE1
								JMP NOT_FREEZED1
								MOVE_FREEZED_BODY1:
								MOV TEMPHEAD, OFFSET BODY_FREEZED
								NOT_FREEZED1:
	DRAW_BODY_SQUARES:          
							   
	                            MOV     AX, SNAKE1_X[BX]
	                            MOV     DX , SNAKE1_Y[BX]
	                            PUSH    BX
	                            MOV     TEMP_HEAD_X ,AX                                       	;set the initial column (X)
	                            MOV     TEMP_HEAD_Y ,DX
	                            PUSH    CX
	                            CALL    DRAW_HEAD
	                            POP     CX
	                            POP     BX
	                            ADD     BX , 2
	                            LOOP    DRAW_BODY_SQUARES
	                            RET
DRAW_SNAKE1 ENDP
DRAW_SNAKE2 PROC NEAR

	                            MOV     CX , SNAKE2_X[0]
	                            MOV     DX , SNAKE2_Y[0]
	                            MOV     TEMP_HEAD_X ,CX                                       	;set the initial column (X)
	                            MOV     TEMP_HEAD_Y ,DX
	                            MOV     AX, SNAKE2_HEAD_DIRECTION
	                            MOV     BX , 2
	                            MUL     BX
	                            MOV     BX , AX
	                            MOV     AX , SNAKE2_HEAD_OFFSETS[BX]
	                            MOV     TEMPHEAD , AX
	                            CALL    DRAW_HEAD
	                            MOV     CX , SNAKE_LEN_ARR[2]
	                            SUB     CX , 1
	                            MOV     BX , 2
								CMP SNAKE2_FREEZE ,0
								JG MOVE_FREEZED_BODY
	                            MOV     TEMPHEAD , OFFSET BODY_SHAPE2
								JMP NOT_FREEZED
								MOVE_FREEZED_BODY:
								MOV TEMPHEAD, OFFSET BODY_FREEZED
								NOT_FREEZED:
	DRAW_BODY_SQUARES2:         
							   
	                            MOV     AX, SNAKE2_X[BX]
	                            MOV     DX , SNAKE2_Y[BX]
	                            PUSH    BX
	                            MOV     TEMP_HEAD_X ,AX                                       	;set the initial column (X)
	                            MOV     TEMP_HEAD_Y ,DX
	                            PUSH    CX
	                            CALL    DRAW_HEAD
	                            POP     CX
	                            POP     BX
	                            ADD     BX , 2
	                            LOOP    DRAW_BODY_SQUARES2
	                            RET
DRAW_SNAKE2 ENDP
CHECK_BITE PROC NEAR

	                            MOV     AX,SNAKE1_X[0]
	                            MOV     BX,SNAKE1_Y[0]
	                            MOV     CX,SNAKE2_X[0]
	                            MOV     DX,SNAKE2_Y[0]
								
	                            CMP     AX,CX
	                            JGE     AX_IS_GREATER_HEAD_CHECKING
	                            XCHG    AX,cx
	AX_IS_GREATER_HEAD_CHECKING:
	                            SUB     AX,CX
	                            CMP     AX,CRITICAL_DIST
	                            JG      END_OF_HEAD_BITE_CHECKING
	                            CMP     BX,DX
	                            JGE     BX_IS_GREATER_HEAD_CHECKING
	                            XCHG    BX,DX
	BX_IS_GREATER_HEAD_CHECKING:
	                            SUB     BX,DX
	                            CMP     BX,CRITICAL_DIST
	                            JG      END_OF_HEAD_BITE_CHECKING
	                            MOV     END_OF_THE_GAME,1
	                            JMP     END_CHECK_BITE

	END_OF_HEAD_BITE_CHECKING:  



	;SNAKE1 BITES SNAKE2
	                            MOV     CX, SNAKE_LEN_ARR[2]
	                            DEC     CX
	                            MOV     BX,2
	CHECK_BITE_SNAKE2:          
	                          
	                            MOV     AX, [SNAKE2_X+BX]
	;PUSH BX     ;;;;;;;;;;                                           	;   AX will INITIALLY contain the x-cordiante of the apple
	                            MOV     TEMP,BX
	                            MOV     BX, SNAKE1_X[0]                                       	;   BX will INITIALLY contain the x-cordiante of the head of snake 1

	                            CMP     AX,BX
	                            JG      AX_IS_GREATER_X                                       	; GE==GREATER EQUAL
	                            XCHG    AX,BX                                                 	; IF BX IS LARGER THAN AX SO XCHG THEM
	AX_IS_GREATER_X:            
	                            MOV     DX,CRITICAL_DIST
	                            SUB     AX,BX                                                 	; AX WILL CONTAIN THE REAL DISTANCE
	                            CMP     AX,DX                                                 	; COMPARE THE DISTANCE BETWEEN SNAKE1_HEAD_CENTER AND APPLE_X BY CRITICAL DISTANCE
	                            JG      GO_TO_LOOP

	                            MOV     BX,TEMP
	                            MOV     AX, [SNAKE2_Y+BX]
	                            MOV     BX,SNAKE1_Y[0]
	                            CMP     AX,BX
	                            JG      AX_IS_GREATER_Y
	                            XCHG    AX,BX

	AX_IS_GREATER_Y:            
	                            MOV     DX,CRITICAL_DIST
	                            SUB     AX,BX                                                 	; AX WILL CONTAIN THE REAL DISTANCE
	                            CMP     AX,DX                                                 	; COMPARE THE DISTANCE BETWEEN SNAKE1_HEAD_CENTER AND APPLE_X BY CRITICAL DISTANCE
	                            JBE     SNAKE1_BITES_SNAKE2_TRUE                              	; CONDITION IS TRUE

	GO_TO_LOOP:                 
	;POP Bx
	                            ADD     TEMP,2
	                            MOV     BX,TEMP
	;ADD BX,2
	                            LOOP    CHECK_BITE_SNAKE2

	                            JMP     CHECK_2
	SNAKE1_BITES_SNAKE2_TRUE:   
	                            MOV     CHOSEN_SNAKE,2
	                            CALL    DECREASE_LEN
	                            MOV     CHOSEN_SNAKE,1
	                            CALL    INCREASE_LEN
	                            MOV     BITE_SENARIO,1
	                            JMP     END_CHECK_BITE
	CHECK_2:                    
	                            MOV     CX, SNAKE_LEN_ARR[0]
	                            DEC     CX
	                            MOV     BX,2
	CHECK_BITE_SNAKE1:          
	                          
	                            MOV     AX, [SNAKE1_X+BX]
	                            MOV     TEMP,BX
	                            MOV     BX, SNAKE2_X[0]                                       	;   BX will INITIALLY contain the x-cordiante of the head of snake 1

	                            CMP     AX,BX
	                            JG      AX_IS_GREATER_X1                                      	; GE==GREATER EQUAL
	                            XCHG    AX,BX                                                 	; IF BX IS LARGER THAN AX SO XCHG THEM
	AX_IS_GREATER_X1:           
	                            MOV     DX,CRITICAL_DIST
	                            SUB     AX,BX                                                 	; AX WILL CONTAIN THE REAL DISTANCE
	                            CMP     AX,DX                                                 	; COMPARE THE DISTANCE BETWEEN SNAKE1_HEAD_CENTER AND APPLE_X BY CRITICAL DISTANCE
	                            JG      GO_TO_LOOP1
	; CONDITION IS FALSE , RET
							  
	                            MOV     BX,TEMP
	                            MOV     AX, [SNAKE1_Y+BX]
							     
	;   AX will INITIALLY contain the x-cordiante of the apple
	                            MOV     BX,SNAKE2_Y[0]

	                            CMP     AX,BX
	                            JG      AX_IS_GREATER_Y1
	                            XCHG    AX,BX

	AX_IS_GREATER_Y1:           
	                            MOV     DX,CRITICAL_DIST
	                            SUB     AX,BX                                                 	; AX WILL CONTAIN THE REAL DISTANCE
	                            CMP     AX,DX                                                 	; COMPARE THE DISTANCE BETWEEN SNAKE1_HEAD_CENTER AND APPLE_X BY CRITICAL DISTANCE
	                            JBE     SNAKE2_BITES_SNAKE1_TRUE                              	; CONDITION IS TRUE

	GO_TO_LOOP1:                
								
	                            ADD     TEMP,2
	                            MOV     BX,TEMP
								
	                            LOOP    CHECK_BITE_SNAKE1

	                            JMP     END_CHECK_BITE
	SNAKE2_BITES_SNAKE1_TRUE:   
	                            MOV     CHOSEN_SNAKE,1
	                            CALL    DECREASE_LEN
	                            MOV     CHOSEN_SNAKE,2
	                            CALL    INCREASE_LEN
	                            MOV     BITE_SENARIO,2
	END_CHECK_BITE:             
	                            RET
CHECK_BITE ENDP


CHECK_FOOD PROC NEAR
	                            MOV     BX,CURR_APPLE_INDEX
	                            MOV     AX, [APPLE_X+BX]                                      	;   AX will INITIALLY contain the x-cordiante of the apple
	                            MOV     BX,SNAKE1_X[0]                                        	;   BX will INITIALLY contain the x-cordiante of the head of snake 1

	                            CMP     BX,AX
	                            JNG     A_GE_B_FOR_X_CHECKING                                 	; GE==GREATER EQUAL
	                            XCHG    AX,BX                                                 	; IF BX IS LARGER THAN AX SO XCHG THEM
	A_GE_B_FOR_X_CHECKING:      
	                            MOV     DX,CRITICAL_DIST
	                            SUB     AX,BX                                                 	; AX WILL CONTAIN THE REAL DISTANCE
	                            CMP     AX,DX                                                 	; COMPARE THE DISTANCE BETWEEN SNAKE1_HEAD_CENTER AND APPLE_X BY CRITICAL DISTANCE
	                            JG      END_OF_SNAKE1_FALSE                                   	; CONDITION IS FALSE , RET

	                            MOV     BX,CURR_APPLE_INDEX
	                            MOV     AX, [APPLE_Y+BX]                                      	;   AX will INITIALLY contain the x-cordiante of the apple
	                            MOV     BX,SNAKE1_Y[0]

	                            CMP     BX,AX
	                            JNG     A_GE_B_FOR_Y_CHECKING
	                            XCHG    AX,BX

	A_GE_B_FOR_Y_CHECKING:      
	                            MOV     DX,CRITICAL_DIST
	                            SUB     AX,BX                                                 	; AX WILL CONTAIN THE REAL DISTANCE
	                            CMP     AX,DX                                                 	; COMPARE THE DISTANCE BETWEEN SNAKE1_HEAD_CENTER AND APPLE_X BY CRITICAL DISTANCE
	                            JBE     END_OF_SNAKE1_TRUE                                    	; CONDITION IS TRUE

	                            JMP     END_OF_SNAKE1_FALSE

	END_OF_SNAKE1_TRUE:                                                                       	; CONDITION IS TRUE
	                            MOV     DX , BGC                                              	; CONDITION IS TRUE
	                            MOV     TEMP_COLOR,BGC                                        	; PREPARING FOR DELETING THE APPLE
	                            MOV     BX,CURR_APPLE_INDEX
	                            MOV     DX,[APPLE_X+BX]
	                            MOV     INIT_SQUARE_X,DX
	                            MOV     DX,[APPLE_Y+BX]
	                            MOV     INIT_SQUARE_Y,DX
	                            CALL    DRAW_SQUARE
	                            ADD     CURR_APPLE_INDEX,2
	                            MOV     CHOSEN_SNAKE,1
	                            CALL    INCREASE_LEN
	                            ADD     NUM_TO_GET_GOLDEN,1
	                            CMP     APPLE_TYPE,1
	                            JNE     NOT_GOLDEN_APPLE1
	                            MOV     CHOSEN_SNAKE,2
	                            CALL    DECREASE_LEN
	                            MOV     NUM_TO_GET_GOLDEN,0
	                            MOV     CHOSEN_SNAKE,1
	NOT_GOLDEN_APPLE1:          

	                            JMP     ENDD


	END_OF_SNAKE1_FALSE:        
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;THE 2ND SNAKE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	                            MOV     BX,CURR_APPLE_INDEX
	                            MOV     AX, [APPLE_X+BX]                                      	;   AX will INITIALLY contain the x-cordiante of the apple
	                            MOV     BX,SNAKE2_X[0]                                        	;   BX will INITIALLY contain the x-cordiante of the head of snake 1

	                            CMP     BX,AX
	                            JNG     A_GE_B_FOR_X_CHECKING2                                	; GE==GREATER EQUAL
	                            XCHG    AX,BX                                                 	; IF BX IS LARGER THAN AX SO XCHG THEM
	A_GE_B_FOR_X_CHECKING2:     
	                            MOV     DX,CRITICAL_DIST
	                            SUB     AX,BX                                                 	; AX WILL CONTAIN THE REAL DISTANCE
	                            CMP     AX,DX                                                 	; COMPARE THE DISTANCE BETWEEN SNAKE1_HEAD_CENTER AND APPLE_X BY CRITICAL DISTANCE
	                            JG      ENDD                                                  	; CONDITION IS FALSE , RET

	                            MOV     BX,CURR_APPLE_INDEX
	                            MOV     AX, [APPLE_Y+BX]                                      	;   AX will INITIALLY contain the x-cordiante of the apple
	                            MOV     BX,SNAKE2_Y[0]

	                            CMP     BX,AX
	                            JNG     A_GE_B_FOR_Y_CHECKING2
	                            XCHG    AX,BX

	A_GE_B_FOR_Y_CHECKING2:     
	                            MOV     DX,CRITICAL_DIST
	                            SUB     AX,BX                                                 	; AX WILL CONTAIN THE REAL DISTANCE
	                            CMP     AX,DX                                                 	; COMPARE THE DISTANCE BETWEEN SNAKE1_HEAD_CENTER AND APPLE_X BY CRITICAL DISTANCE
	                            JBE     END_OF_SNAKE2_TRUE2                                   	; CONDITION IS TRUE

	                            JMP     ENDD

	END_OF_SNAKE2_TRUE2:                                                                      	; CONDITION IS TRUE
	                            MOV     DX , BGC                                              	; CONDITION IS TRUE
	                            MOV     TEMP_COLOR,BGC                                        	; PREPARING FOR DELETING THE APPLE
	                            MOV     BX,CURR_APPLE_INDEX
	                            MOV     DX,[APPLE_X+BX]
	                            MOV     INIT_SQUARE_X,DX
	                            MOV     DX,[APPLE_Y+BX]
	                            MOV     INIT_SQUARE_Y,DX
	                            CALL    DRAW_SQUARE
	                            ADD     CURR_APPLE_INDEX,2
	                            MOV     CHOSEN_SNAKE,2
	                            CALL    INCREASE_LEN
	                            ADD     NUM_TO_GET_GOLDEN,1
	                            CMP     APPLE_TYPE,1
	                            JNE     NOT_GOLDEN_APPLE2
	                            MOV     CHOSEN_SNAKE,1
	                            CALL    DECREASE_LEN
	                            MOV     NUM_TO_GET_GOLDEN,0
	                            MOV     CHOSEN_SNAKE,2
	NOT_GOLDEN_APPLE2:          

	                            JMP     ENDD
							  
							
	ENDD:                       
	                            RET
CHECK_FOOD ENDP

DRAW_SNAKES2 PROC NEAR
	                            CALL    DRAW_SNAKE1
	                            CALL    DRAW_SNAKE2
	                            RET
DRAW_SNAKES2 ENDP

DRAW_SNAKES1 PROC NEAR
	                            CALL    DRAW_SNAKE2
	                            CALL    DRAW_SNAKE1

	                            RET
DRAW_SNAKES1 ENDP

DRAW_SNAKES PROC NEAR
	                            CMP     BITE_SENARIO , 2
	                            JZ      SEN2
	                            JMP     SEN1
	SEN2:                       
	                            CALL    DRAW_SNAKES2
	                            JMP     END_THIS_PROC
	SEN1:                       
	                            CALL    DRAW_SNAKES1

	END_THIS_PROC:              
	                            RET
DRAW_SNAKES ENDP

TWO_IS_FREEZED PROC  NEAR
	                            CMP     SNAKE2_FREEZE , 0
	                            JZ      TWO_NOT_FREEZED
	                            MOV     TEMP_HEAD_X , 150
	                            MOV     TEMP_HEAD_Y , 25
	                            MOV     TEMPHEAD , OFFSET FREEZED
	                            CALL    DRAW_HEAD
	                            JMP     END_FUNC2
	TWO_NOT_FREEZED:            
	                            MOV     INIT_SQUARE_X , 150
	                            MOV     INIT_SQUARE_Y , 25
	                            MOV     TEMP_COLOR , 00H
	                            CALL    DRAW_SQUARE
	END_FUNC2:                  
	                            RET
TWO_IS_FREEZED ENDP
ONE_IS_FREEZED PROC  NEAR
	                            CMP     SNAKE1_FREEZE , 0
	                            JZ      ONE_NOT_FREEZED
	                            MOV     TEMP_HEAD_X , 450
	                            MOV     TEMP_HEAD_Y , 25
	                            MOV     TEMPHEAD , OFFSET FREEZED
	                            CALL    DRAW_HEAD
	                            JMP     END_FUNC1
	ONE_NOT_FREEZED:            
	                            MOV     INIT_SQUARE_X , 450
	                            MOV     INIT_SQUARE_Y , 25
	                            MOV     TEMP_COLOR , 00H
	                            CALL    DRAW_SQUARE
	END_FUNC1:                  
	                            RET
ONE_IS_FREEZED ENDP
	; SEND PROC NEAR
	; mov dx , 3FDH ; Line Status Register
	; AGAIN: In al , dx ;Read Line Status
	; test al , 00100000b
	; JZ AGAIN ;Not empty (This line may need to change)
	; ;If empty put the VALUE in Transmit data register
	; mov dx , 3F8H ; Transmit data register
	; mov al,VALUE
	; out dx , al
	; RET
	; SEND ENDP
SEND_DATA PROC NEAR
	                            mov     value , 'A'
	                            SEND
	; 18 SNAKE1_X
	                            MOV     CX , 18
	                            MOV     BX , 0
	LS1:                        
	                            MOV     AL , BYTE PTR SNAKE1_X[BX]
	                            MOV     VALUE, AL
	                            PUSH    BX
	                            PUSH    CX
	                            SEND
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LS1

	; mov     value , 'B'
	; SEND
	; 18 SNAKE1_Y
	                            MOV     CX , 18
	                            MOV     BX , 0
	LS2:                        
	                            MOV     AL , BYTE PTR SNAKE1_Y[BX]
	                            MOV     VALUE, AL
	                            PUSH    BX
	                            PUSH    CX
	                            SEND
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LS2

	; mov     value , 'C'
	; SEND

	; 18 SNAKE2_X
	                            MOV     CX , 18
	                            MOV     BX , 0
	LS3:                        
	                            MOV     AL , BYTE PTR SNAKE2_X[BX]
	                            MOV     VALUE, AL
	                            PUSH    BX
	                            PUSH    CX
	                            SEND
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LS3

	; mov     value , 'D'
	; SEND
	; 18 SNAKE2_Y
	                            MOV     CX , 18
	                            MOV     BX , 0
	LS4:                        
	                            MOV     AL , BYTE PTR SNAKE2_Y[BX]
	                            MOV     VALUE, AL
	                            PUSH    BX
	                            PUSH    CX
	                            SEND
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LS4

	; mov     value , 'E'
	; SEND

	; 4 LEN_ARR
	                            MOV     CX , 4
	                            MOV     BX , 0
	LS5:                        
	                            MOV     AL , BYTE PTR SNAKE_LEN_ARR[BX]
	                            MOV     VALUE, BYTE PTR AL
	                            PUSH    BX
	                            PUSH    CX
	                            SEND
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LS5

	; mov     value , 'F'
	; SEND
	; 2 SCORE1
	                            MOV     CX , 2
	                            MOV     BX , 0
	LS6:                        
	                            MOV     AL , BYTE PTR PLAYER1_SCORE[BX]
	                            MOV     VALUE, AL
	                            PUSH    BX
	                            PUSH    CX
	                            SEND
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LS6

	; mov     value , 'G'
	; SEND

	; 2 SCORE2
	                            MOV     CX , 2
	                            MOV     BX , 0
	LS7:                        
	                            MOV     AL , BYTE PTR PLAYER2_SCORE[BX]
	                            MOV     VALUE, AL
	                            PUSH    BX
	                            PUSH    CX
	                            SEND
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LS7

	; mov     value , 'H'
	; SEND

	; SECONDS
	                            MOV     AL , DISPLAYED_SECONDS
	                            MOV     VALUE, AL
	                            SEND

	; mov     value , 'I'
	; SEND
	;MINS
	                            MOV     AL , DISPLAYED_MINUTES
	                            MOV     VALUE, AL
	                            SEND

	; mov     value , 'J'
	; SEND

	; 2 INDEX_FIRE
	                            MOV     CX , 2
	                            MOV     BX , 0
	LS8:                        
	                            MOV     AL , BYTE PTR CURR_FIRE_INDEX[BX]
	                            MOV     VALUE, AL
	                            PUSH    BX
	                            PUSH    CX
	                            SEND
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LS8

	; mov     value , 'K'
	; SEND
	; 2 INDEX_APPLE
	                            MOV     CX , 2
	                            MOV     BX , 0
	LS9:                        
	                            MOV     AL , BYTE PTR CURR_APPLE_INDEX[BX]
	                            MOV     VALUE, AL
	                            PUSH    BX
	                            PUSH    CX
	                            SEND
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LS9

	; mov     value , 'L'
	; SEND
	; 2 SNAKE1_HEAD_DIR
	                            MOV     CX , 2
	                            MOV     BX , 0
	LS10:                       
	                            MOV     AL , BYTE PTR SNAKE1_HEAD_DIRECTION[BX]
	                            MOV     VALUE, AL
	                            PUSH    BX
	                            PUSH    CX
	                            SEND
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LS10

	; mov     value , 'M'
	; SEND


	; 2 SNAKE2_HEAD_DIR
	                            MOV     CX , 2
	                            MOV     BX , 0
	LS11:                       
	                            MOV     AL , BYTE PTR SNAKE2_HEAD_DIRECTION[BX]
	                            MOV     VALUE, AL
	                            PUSH    BX
	                            PUSH    CX
	                            SEND
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LS11
								
								
	                            MOV     CX , 2
	                            MOV     BX , 0
	LS12:                       
	                            MOV     AL , BYTE PTR END_OF_THE_GAME[BX]
	                            MOV     VALUE, AL
	                            PUSH    BX
	                            PUSH    CX
	                            SEND
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LS12
	                            MOV     CX , 2
	                            MOV     BX , 0
	LS13:                       
	                            MOV     AL , BYTE PTR SNAKE1_FREEZE[BX]
	                            MOV     VALUE, AL
	                            PUSH    BX
	                            PUSH    CX
	                            SEND
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LS13

	                            MOV     CX , 2
	                            MOV     BX , 0
	LS14:                       
	                            MOV     AL , BYTE PTR SNAKE2_FREEZE[BX]
	                            MOV     VALUE, AL
	                            PUSH    BX
	                            PUSH    CX
	                            SEND
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LS14


	                            MOV     AL , NUM_TO_GET_GOLDEN
	                            MOV     VALUE, AL
	                            SEND
								
	                            MOV     AL , open_chat
	                            MOV     VALUE, AL
	                            SEND


	                            RET
	; mov al , 20h
	; mov value , al
	; send
	; mov value , 10h
	; send
	; mov value , 15h
	; send
	; mov value , 00h
	; send
	; mov value , 0eh
	; send

	; mov value , 'A'
	; SEND
	; ; 18 SNAKE1_X
	; MOV CX , 18
	; MOV BX , 0
	; LS1:
	; MOV AL , BYTE PTR SNAKE1_X[BX]
	; MOV VALUE, AL
	; PUSH BX
	; PUSH CX
	; SEND
	; POP CX
	; POP BX
	; INC BX
	; LOOP LS1

	; mov value , 'B'
	; SEND
	; ; 18 SNAKE1_Y
	; MOV CX , 18
	; MOV BX , 0
	; LS2:
	; MOV AL , BYTE PTR SNAKE1_Y[BX]
	; MOV VALUE, AL
	; PUSH BX
	; PUSH CX
	; SEND
	; POP CX
	; POP BX
	; INC BX
	; LOOP LS2

	; mov value , 'C'
	; SEND

	; ; 18 SNAKE2_X
	; MOV CX , 18
	; MOV BX , 0
	; LS3:
	; MOV AL , BYTE PTR SNAKE2_X[BX]
	; MOV VALUE, AL
	; PUSH BX
	; PUSH CX
	; SEND
	; POP CX
	; POP BX
	; INC BX
	; LOOP LS3

	; mov value , 'D'
	; SEND
	; ; 18 SNAKE2_Y
	; MOV CX , 18
	; MOV BX , 0
	; LS4:
	; MOV AL , BYTE PTR SNAKE2_Y[BX]
	; MOV VALUE, AL
	; PUSH BX
	; PUSH CX
	; SEND
	; POP CX
	; POP BX
	; INC BX
	; LOOP LS4

	; mov value , 'E'
	; SEND

	; ; 4 LEN_ARR
	; MOV CX , 4
	; MOV BX , 0
	; LS5:
	; MOV AL , BYTE PTR SNAKE_LEN_ARR[BX]
	; MOV VALUE, BYTE PTR AL
	; PUSH BX
	; PUSH CX
	; SEND
	; POP CX
	; POP BX
	; INC BX
	; LOOP LS5

	; mov value , 'F'
	; SEND
	; ; 2 SCORE1
	; MOV CX , 2
	; MOV BX , 0
	; LS6:
	; MOV AL , BYTE PTR PLAYER1_SCORE[BX]
	; MOV VALUE, AL
	; PUSH BX
	; PUSH CX
	; SEND
	; POP CX
	; POP BX
	; INC BX
	; LOOP LS6

	; mov value , 'G'
	; SEND

	; ; 2 SCORE2
	; MOV CX , 2
	; MOV BX , 0
	; LS7:
	; MOV AL , BYTE PTR PLAYER2_SCORE[BX]
	; MOV VALUE, AL
	; PUSH BX
	; PUSH CX
	; SEND
	; POP CX
	; POP BX
	; INC BX
	; LOOP LS7

	; mov value , 'H'
	; SEND

	; ; SECONDS
	; MOV AL , DISPLAYED_SECONDS
	; MOV VALUE, AL
	; SEND

	; mov value , 'I'
	; SEND
	; ;MINS
	; MOV AL , DISPLAYED_MINUTES
	; MOV VALUE, AL
	; SEND

	; mov value , 'J'
	; SEND

	; ; 2 INDEX_FIRE
	; MOV CX , 2
	; MOV BX , 0
	; LS8:
	; MOV AL , BYTE PTR CURR_FIRE_INDEX[BX]
	; MOV VALUE, AL
	; PUSH BX
	; PUSH CX
	; SEND
	; POP CX
	; POP BX
	; INC BX
	; LOOP LS8

	; mov value , 'K'
	; SEND
	; ; 2 INDEX_APPLE
	; MOV CX , 2
	; MOV BX , 0
	; LS9:
	; MOV AL , BYTE PTR CURR_APPLE_INDEX[BX]
	; MOV VALUE, AL
	; PUSH BX
	; PUSH CX
	; SEND
	; POP CX
	; POP BX
	; INC BX
	; LOOP LS9

	; mov value , 'L'
	; SEND
	; ; 2 SNAKE1_HEAD_DIR
	; MOV CX , 2
	; MOV BX , 0
	; LS10:
	; MOV AL , BYTE PTR SNAKE1_HEAD_DIRECTION[BX]
	; MOV VALUE, AL
	; PUSH BX
	; PUSH CX
	; SEND
	; POP CX
	; POP BX
	; INC BX
	; LOOP LS10

	; mov value , 'M'
	; SEND


	; ; 2 SNAKE2_HEAD_DIR
	; MOV CX , 2
	; MOV BX , 0
	; LS11:
	; MOV AL , BYTE PTR SNAKE2_HEAD_DIRECTION[BX]
	; MOV VALUE, AL
	; PUSH BX
	; PUSH CX
	; SEND
	; POP CX
	; POP BX
	; INC BX
	; LOOP LS11

SEND_DATA ENDP
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RECEIVE_DATA PROC NEAR
	; rrr:
	; receive
	; cmp value , 'A'
	; jnz rrr
	; receive
	; mov     al , value
	; ;mov 	ah, 0
	; mov     bl , al
	; mov     bh , 00
	; receive
	;  mov     al , value
	;  mov     byte ptr init_square_x[0] , al
	; receive
	;  mov     al , value
	;  mov     byte ptr init_square_x[1] , al
	; receive
	;  mov     al , value
	;  mov     byte ptr init_square_y[0] , al
	;  receive
	;  mov     al , value
	;  mov     byte ptr init_square_y[1] , al
	;  receive
	; mov     al , value
	; mov     temp_color , al

	; RECEIVE
	; RE1:
	; MOV TEMP_HEAD_X , 200
	; MOV TEMP_HEAD_Y , 300
	; MOV TEMPHEAD , OFFSET FIRE
	; CALL DRAW_HEAD
	; CMP value , 'A'
	; JNZ RE1
	; ; 18 SNAKE1_X
	; MOV CX , 18
	; MOV BX , 0
	; LR1:
	; PUSH BX
	; PUSH CX
	; RECEIVE
	; MOV AL , VALUE
	; MOV BYTE PTR SNAKE1_X[BX] , AL
	; POP CX
	; POP BX
	; INC BX
	; LOOP LR1

	RE1:                        
	                            RECEIVE
	                            CMP     value , 'A'
	                            JNZ     RE1
	; 18 SNAKE1_X
	                            MOV     CX , 18
	                            MOV     BX , 0
	LR1:                        
	                            PUSH    BX
	                            PUSH    CX
	                            RECEIVE
	                            MOV     AL , VALUE
	                            MOV     BYTE PTR SNAKE1_X[BX] , AL
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LR1

	; RECEIVE
	; CMP value , 'B'
	; JNZ RE1
	; 18 SNAKE1_Y
	                            MOV     CX , 18
	                            MOV     BX , 0
	LR2:                        
	                            PUSH    BX
	                            PUSH    CX
	                            RECEIVE
	                            MOV     AL , VALUE
	                            MOV     BYTE PTR SNAKE1_Y[BX] , AL
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LR2

	; RECEIVE
	; CMP value , 'C'
	; JNZ RE1

	; 18 SNAKE2_X
	                            MOV     CX , 18
	                            MOV     BX , 0
	LR3:                        
	                            PUSH    BX
	                            PUSH    CX
	                            RECEIVE
	                            MOV     AL , VALUE
	                            MOV     BYTE PTR SNAKE2_X[BX] , AL
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LR3

	; RECEIVE
	; CMP value , 'D'
	; JNZ RE1
	; 18 SNAKE2_Y
	                            MOV     CX , 18
	                            MOV     BX , 0
	LR4:                        
	                            PUSH    BX
	                            PUSH    CX
	                            RECEIVE
	                            MOV     AL , VALUE
	                            MOV     BYTE PTR SNAKE2_Y[BX] , AL
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LR4

	; RECEIVE
	; CMP value , 'E'
	; JNZ RE1

	; 4 LEN_ARR
	                            MOV     CX , 4
	                            MOV     BX , 0
	LR5:                        
	                            PUSH    BX
	                            PUSH    CX
	                            RECEIVE
	                            MOV     AL , VALUE
	                            MOV     BYTE PTR SNAKE_LEN_ARR[BX] , AL
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LR5

	; RECEIVE
	; CMP value , 'F'
	; JNZ RE1
	; 2 SCORE1
	                            MOV     CX , 2
	                            MOV     BX , 0
	LR6:                        
	                            PUSH    BX
	                            PUSH    CX
	                            RECEIVE
	                            MOV     AL , VALUE
	                            MOV     BYTE PTR PLAYER1_SCORE[BX] , AL
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LR6

	; RECEIVE
	; CMP value , 'G'
	; JNZ RE1

	; 2 SCORE2
	                            MOV     CX , 2
	                            MOV     BX , 0
	LR7:                        
	                            PUSH    BX
	                            PUSH    CX
	                            RECEIVE
	                            MOV     AL , VALUE
	                            MOV     BYTE PTR PLAYER2_SCORE[BX] , AL
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LR7

	; RECEIVE
	; CMP value , 'H'
	; JNZ RE1

	; SECONDS
	                            RECEIVE
	                            MOV     VALUE, AL
	                            MOV     DISPLAYED_SECONDS , AL

	; RECEIVE
	; CMP value , 'I'
	; JZ RE1
	;MINS
	                            RECEIVE
	                            MOV     AL , VALUE
	                            MOV     DISPLAYED_MINUTES  ,AL

	; RECEIVE
	; CMP value , 'J'
	; JNZ RE1

	; 2 INDEX_FIRE
	                            MOV     CX , 2
	                            MOV     BX , 0
	LR8:                        
	                            PUSH    BX
	                            PUSH    CX
	                            RECEIVE
	                            MOV     AL , VALUE
	                            MOV     BYTE PTR CURR_FIRE_INDEX[BX] , AL
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LR8

	; RECEIVE
	; CMP value , 'K'
	; JNZ RE1
	; 2 INDEX_APPLE
	                            MOV     CX , 2
	                            MOV     BX , 0
	LR9:                        
	                            PUSH    BX
	                            PUSH    CX
	                            RECEIVE
	                            MOV     AL , VALUE
	                            MOV     BYTE PTR CURR_APPLE_INDEX[BX] , AL
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LR9

	; RECEIVE
	; CMP value , 'L'
	; JNZ RE1
	; 2 SNAKE1_HEAD_DIR
	                            MOV     CX , 2
	                            MOV     BX , 0
	LR10:                       
	                            PUSH    BX
	                            PUSH    CX
	                            RECEIVE
	                            MOV     AL , VALUE
	                            MOV     BYTE PTR SNAKE1_HEAD_DIRECTION[BX] , AL
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LR10

	; RECEIVE
	; CMP value , 'M'
	; JNZ RE1


	; 2 SNAKE2_HEAD_DIR
	                            MOV     CX , 2
	                            MOV     BX , 0
	LR11:                       
	                            PUSH    BX
	                            PUSH    CX
	                            RECEIVE
	                            MOV     AL , VALUE
	                            MOV     BYTE PTR SNAKE2_HEAD_DIRECTION[BX] , AL
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LR11

	                            MOV     CX , 2
	                            MOV     BX , 0
	LR12:                       
	                            PUSH    BX
	                            PUSH    CX
	                            RECEIVE
	                            MOV     AL , VALUE
	                            MOV     BYTE PTR END_OF_THE_GAME[BX] , AL
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LR12

	                            MOV     CX , 2
	                            MOV     BX , 0
	LR13:                       
	                            PUSH    BX
	                            PUSH    CX
	                            RECEIVE
	                            MOV     AL , VALUE
	                            MOV     BYTE PTR SNAKE1_FREEZE[BX] , AL
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LR13

	                            MOV     CX , 2
	                            MOV     BX , 0
	LR14:                       
	                            PUSH    BX
	                            PUSH    CX
	                            RECEIVE
	                            MOV     AL , VALUE
	                            MOV     BYTE PTR SNAKE2_FREEZE[BX] , AL
	                            POP     CX
	                            POP     BX
	                            INC     BX
	                            LOOP    LR14

	                            RECEIVE
	                            MOV     VALUE, AL
	                            MOV     NUM_TO_GET_GOLDEN , AL

	                            RECEIVE
	                            MOV     VALUE, AL
	                            MOV     open_chat , AL

	                            RET
	

RECEIVE_DATA ENDP




PRINT_TIME2 PROC NEAR
	PRINT_CURR_TIME2:           
	                            MOV     AL,DISPLAYED_MINUTES
	                            MOV     MINUTES,AL
	                            MOV     AL,DISPLAYED_SECONDS
	                            MOV     SECONDS,AL
	;mov  al, seconds              	;;;divide if seconds two digit
	                            mov     bh,10
	                            mov     ah,00
	                            div     bh
	                            mov     temp_sec2,ah
	                            mov     temp_sec1,al

	;;;;;;;;;;;;;;;;;;;;;;;;print minute;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	                            mov     dl,22h
	                            mov     dh,1h                                                 	;row
	                            mov     bh,0
	                            mov     ah,02h
	                            int     10h
	                            mov     bl,1                                                  	;color
	                            mov     al,minutes
	                            add     al,30h
	                            mov     ah,0eh                                                	;
	                            int     10h

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;print colon;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;print colon;;;;;


	                            mov     dl,23h                                                	;column
	                            mov     ah,02h
	                            int     10h
	                            mov     al,3ah
	                            mov     ah,0eh                                                	;
	                            int     10h
	;;;;;;;;;;;;;;;;;;;;;;;;print second;;;;;;;;;;;;;;;;;;;;;;;
	                            mov     dl,24h                                                	;column
	                            mov     ah,02h
	                            int     10h
	                            mov     al, temp_sec1
	                            add     al,30h
	                            mov     ah,0eh                                                	;
	                            int     10h
	;;;;;;;;;;;;;;;;;;;;;;;second digit;;;;;;;;;;;;;;;;;;;;;;;;;;
	                            mov     dl,25h                                                	;column
	                            mov     ah,02h
	                            int     10h
	                            mov     al,temp_sec2
	                            add     al,30h
	                            mov     ah,0eh                                                	;
			
	                            int     10h


	                            JMP     END_PRINT_TIME_PROC2

	TIME_OUT2:                  
	                    

	END_PRINT_TIME_PROC2:       

	                            RET
PRINT_TIME2 ENDP


DELETE_FOR_PLAYER2 PROC NEAR
	                            MOV     SI,OFFSET APPLE_X
	                            MOV     BX, TEMP_CURR_APPLE_INDEX
	                            MOV     DX, [SI+BX]
	                            MOV     INIT_SQUARE_X ,DX

	                            MOV     SI,OFFSET APPLE_Y
	                            MOV     BX, TEMP_CURR_APPLE_INDEX
	                            MOV     DX, [SI+BX]
	                            MOV     INIT_SQUARE_Y ,DX
			 
	                            MOV     TEMP_COLOR, BGC
	                            CALL    DRAW_SQUARE
	                            MOV     SI,OFFSET FIRE_X
	                            MOV     BX, TEMP_CURR_FIRE_INDEX
	                            MOV     DX, [SI+BX]
	                            MOV     INIT_SQUARE_X ,DX

	                            MOV     SI,OFFSET FIRE_Y
	                            MOV     BX, TEMP_CURR_FIRE_INDEX
	                            MOV     DX, [SI+BX]
	                            MOV     INIT_SQUARE_Y ,DX
			 
	                            MOV     TEMP_COLOR, BGC
	                            CALL    DRAW_SQUARE
								
	                            MOV     CX , TEMP_SNAKE1_X[0]
	                            MOV     DX , TEMP_SNAKE1_Y[0]
	                            MOV     INIT_SQUARE_X ,CX                                     	;set the initial column (X)
	                            MOV     INIT_SQUARE_Y ,DX                                     	;set the initial line (Y)
	                            MOV     TEMP_COLOR , BGC
	                            CALL    DRAW_SQUARE
	                            MOV     CX , TEMP_SNAKE_LEN_ARR[0]
	                            SUB     CX , 1
	                            MOV     BX , 2
	                            MOV     TEMP_COLOR, BGC
	DELETE_BODY_SQUARES:        
							   
	                            MOV     AX, TEMP_SNAKE1_X[BX]
	                            MOV     DX , TEMP_SNAKE1_Y[BX]
	                            PUSH    BX
	                            MOV     INIT_SQUARE_X ,AX                                     	;set the initial column (X)
	                            MOV     INIT_SQUARE_Y ,DX
	                            PUSH    CX
	                            CALL    DRAW_SQUARE
	                            POP     CX
	                            POP     BX
	                            ADD     BX , 2
	                            LOOP    DELETE_BODY_SQUARES

	                            MOV     CX , TEMP_SNAKE2_X[0]
	                            MOV     DX , TEMP_SNAKE2_Y[0]
	                            MOV     INIT_SQUARE_X ,CX                                     	;set the initial column (X)
	                            MOV     INIT_SQUARE_Y ,DX                                     	;set the initial line (Y)
	                            MOV     TEMP_COLOR , BGC
	                            CALL    DRAW_SQUARE
	                            MOV     CX , TEMP_SNAKE_LEN_ARR[2]
	                            SUB     CX , 1
	                            MOV     BX , 2
	                            MOV     TEMP_COLOR, BGC
	DELETE_BODY2_SQUARES:       
							   
	                            MOV     AX, TEMP_SNAKE2_X[BX]
	                            MOV     DX , TEMP_SNAKE2_Y[BX]
	                            PUSH    BX
	                            MOV     INIT_SQUARE_X ,AX                                     	;set the initial column (X)
	                            MOV     INIT_SQUARE_Y ,DX
	                            PUSH    CX
	                            CALL    DRAW_SQUARE
	                            POP     CX
	                            POP     BX
	                            ADD     BX , 2
	                            LOOP    DELETE_BODY2_SQUARES
	                            RET
DELETE_FOR_PLAYER2 ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOVE_SNAKE PROC NEAR

	START:                      
	BEG:                        
	;Check that Data is Ready
	                            mov     dx , 3FDH                                             	; Line Status Register
	                            in      al , dx
	                            test    al , 1
	                            JZ      CHK                                                   	;Not Ready (This line may need to change)
	;If Ready read the VALUE in Receive data register
	                            mov     dx , 03F8H
	                            in      al , dx
	                            mov     VALUE , al
	                            MOV     AH , VALUE
	                            JMP     BEG1
	CHK:                        
	                            mov     ah,1
	                            int     16h
	                            JNZ     BEG2
	                            JMP     BEG
	BEG2:                       
	                            mov     ah,0
	                            int     16h
	BEG1:                       
						
	                            CMP     AH ,72
	                            JZ      SNAKE_1_HELP
	                            CMP     AH ,80
	                            JZ      SNAKE_1_HELP
	                            CMP     AH,77
	                            JZ      SNAKE_1_HELP
	                            CMP     AH,75
	                            JZ      SNAKE_1_HELP
	                   
							
	         
	                            CMP     AH ,11H
	                            JZ      SNAKE_1_HELP
	                            CMP     AH ,1FH
	                            JZ      SNAKE_1_HELP
	                            CMP     AH,20H
	                            JZ      SNAKE_1_HELP
	                            CMP     AH,1EH
	                            JZ      SNAKE_1_HELP

	                            JMP     START


	SNAKE_1_HELP:               
	                            JMP     SNAKE_1

	NEW_START:                  

	; CALL SEND_DATA
	; mov bl , 1
	; add to_send , bl

	                            CALL    Print_time
	                            CALL    DRAW_APPLE
	                            CALL    CHECK_FOOD
	                            CALL    DRAW_FIRE
	                            CALL    CHECK_FIRE
	                            CALL    print_score_player1
	                            CALL    print_score_player2
	                            CALL    CHECK_BITE
	                            CALL    ONE_IS_FREEZED
	                            CALL    TWO_IS_FREEZED
	                            CALL    DRAW_SNAKES
	                            CALL    SEND_DATA
	                            CMP     END_OF_THE_GAME,0
	                            JNZ     RETURN_TO_MAIN_HELP_HELP
								

	                            CMP     NUM_C_EAT_SNAKE1 , 3
	                            JE      FREEZE_SNAKE2
	                            CMP     NUM_C_EAT_SNAKE2,3
	                            JNE     END_OF_FREEZE_CHECKING
	                            MOV     NUM_C_EAT_SNAKE2,0
	                            MOV     DX, POWER_UP1_PENALITY
	                            MOV     SNAKE1_FREEZE,DX
	                            JMP     END_OF_FREEZE_CHECKING
								
	FREEZE_SNAKE2:              
	                            MOV     NUM_C_EAT_SNAKE1,0
	                            MOV     DX, POWER_UP1_PENALITY
	                            MOV     SNAKE2_FREEZE,DX
	END_OF_FREEZE_CHECKING:     

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DELAY MACRO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	                            MOV     CX,0000H
	                            MOV     DX,LVL_SPEED
	                            MOV     AH,86H
	                            INT     15H
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	;Check that Data is Ready
	                            mov     dx , 3FDH                                             	; Line Status Register
	                            in      al , dx
	                            test    al , 1
	                            JZ      CHK1                                                  	;Not Ready (This line may need to change)
	;If Ready read the VALUE in Receive data register
	                            mov     dx , 03F8H
	                            in      al , dx
	                            mov     VALUE , al
	                            MOV     AH , VALUE
	                            JMP     AS_GETTING_KEY
	CHK1:                       
	                            MOV     AH,1
	                            INT     16h
	                            JZ      GO_AS_BEFORE

	                            MOV     AH,0
	                            INT     16H
								
	                            CMP     AH ,11H
	                            JZ      player1_pressed_wsad
	                            CMP     AH ,1FH
	                            JZ      player1_pressed_wsad
	                            CMP     AH,20H
	                            JZ      player1_pressed_wsad
	                            CMP     AH,1EH
	                            JZ      player1_pressed_wsad
	                            jmp     skip_player1_pressed_wsad

	player1_pressed_wsad:       
	                            mov     ah,TEMP_BUFFER1
	skip_player1_pressed_wsad:  
	AS_GETTING_KEY:             
                               
	SNAKE_1:                    
	
	                            CMP     AH ,3EH
	                            JZ      RETT
	                            CMP     AH,3CH
	                            JZ      game_chat
	                            JMP     CONTIN
	RETT:                       
	                            mov     END_OF_THE_GAME,1
	                            CALL    SEND_DATA
	                            RET
	game_chat:                  
	                            cmp     value , 3ch
	                            jz      ignore_send
	                            mov     open_chat , 1
	                            call    send_data
	ignore_send:                
	                            call    inline_chat
	                            mov     open_chat , 0
	                            call    send_data
	CONTIN:                     
	                            CMP     AH ,72
	                            JZ      UP1_HELP_HELP
	                            CMP     AH ,80
	                            JZ      DOWN1_HELP_HELP
	                            CMP     AH,77
	                            JZ      RIGHT1_HELP_HELP
	                            CMP     AH,75
	                            JZ      LEFT1_HELP_HELP

	                       


	SNAKE_2:                    
	                            CMP     AH ,11H
	                            JZ      UPDATE_TEMP_BUFFER2
	                            CMP     AH ,1FH
	                            JZ      UPDATE_TEMP_BUFFER2
	                            CMP     AH,20H
	                            JZ      UPDATE_TEMP_BUFFER2
	                            CMP     AH,1EH
	                            JZ      UPDATE_TEMP_BUFFER2


	                            JMP     GO_AS_BEFORE



	RETURN_TO_MAIN_HELP_HELP:   
	                            JMP     RETURN_TO_MAIN_HELP
	UP1_HELP_HELP:              
	                            JMP     UP1_HELP

	RIGHT1_HELP_HELP:           
	                            JMP     RIGHT1_HELP

	DOWN1_HELP_HELP:            
	                            JMP     DOWN1_HELP
	

	LEFT1_HELP_HELP:            
	                            JMP     LEFT1_HELP

	




	UPDATE_TEMP_BUFFER2:        
	                            MOV     TEMP_BUFFER2,AH
	                            MOV     AH,TEMP_BUFFER1
	                            JMP     SNAKE_1


	GO_AS_BEFORE:               

								
	;CMP  SNAKE1_FREEZE,0
	;JNE  SNAKE1_IS_FREEZED

	                            CMP     TEMP_BUFFER1 ,72
	                            JZ      UP1
	                            CMP     TEMP_BUFFER1 ,80
	                            JZ      DOWN1
	                            CMP     TEMP_BUFFER1,77
	                            JZ      RIGHT1
	                            CMP     TEMP_BUFFER1,75
	                            JZ      LEFT1

	                   
	SNAKE2_LABEL:               

	                            CMP     TEMP_BUFFER2 ,11H
	                            JZ      UP2_HELP_HELP
	                            CMP     TEMP_BUFFER2 ,1FH
	                            JZ      DOWN2_HELP_HELP
	                            CMP     TEMP_BUFFER2,20H
	                            JZ      RIGHT2_HELP_HELP
	                            CMP     TEMP_BUFFER2,1EH
	                            JZ      LEFT2_HELP_HELP

	;SNAKE2_IS_FREEZED:
	;  DEC  SNAKE2_FREEZE
	                            JMP     NEW_START                                             	;

	UP1_HELP:                   
	                            JMP     UP1
	DOWN1_HELP:                 
	                            JMP     DOWN1
	LEFT1_HELP:                 
	                            JMP     LEFT1
	RIGHT1_HELP:                
	                            JMP     RIGHT1
	UP2_HELP_HELP:              
	                            JMP     UP2_HELP

	DOWN2_HELP_HELP:            
	                            JMP     DOWN2_HELP

	RIGHT2_HELP_HELP:           
	                            JMP     RIGHT2_HELP

	LEFT2_HELP_HELP:            
	                            JMP     LEFT2_HELP

	RETURN_TO_MAIN_HELP:        
	                            JMP     RETURN_TO_MAIN


	UP1:                        
	      
	                            CMP     SNAKE1_FREEZE , 0
	                            JNZ     SKIP_UP1
	                            CALL    MOVE_SNAKE1_UP
	                            MOV     TEMP_BUFFER1,72
	                            JMP     SNAKE2_LABEL
	SKIP_UP1:                   
	                            DEC     SNAKE1_FREEZE
	                            JMP     SNAKE2_LABEL

	DOWN1:                      
	                            CMP     SNAKE1_FREEZE , 0
	                            JNZ     SKIP_DOWN1
	                            CALL    MOVE_SNAKE1_DOWN
	                            MOV     TEMP_BUFFER1,80
	                            JMP     SNAKE2_LABEL
	SKIP_DOWN1:                 
	                            DEC     SNAKE1_FREEZE
	                            JMP     SNAKE2_LABEL

	RIGHT1:                     
	                            CMP     SNAKE1_FREEZE , 0
	                            JNZ     SKIP_RIGHT1
	                            CALL    MOVE_SNAKE1_RIGHT
	                            MOV     TEMP_BUFFER1,77
	                            JMP     SNAKE2_LABEL
	SKIP_RIGHT1:                
	                            DEC     SNAKE1_FREEZE
	                            JMP     SNAKE2_LABEL
	LEFT1:                      
	                            CMP     SNAKE1_FREEZE , 0
	                            JNZ     SKIP_LEFT1
	                            CALL    MOVE_SNAKE1_LEFT
	                            MOV     TEMP_BUFFER1,75
	                            JMP     SNAKE2_LABEL
	SKIP_LEFT1:                 
	                            DEC     SNAKE1_FREEZE
	                            JMP     SNAKE2_LABEL

	                    
	UP2_HELP:                   
	                            JMP     UP2
	DOWN2_HELP:                 
	                            JMP     DOWN2
	LEFT2_HELP:                 
	                            JMP     LEFT2
	RIGHT2_HELP:                
	                            JMP     RIGHT2





	UP2:                        
	                            CMP     SNAKE2_FREEZE,0
	                            JNZ     SKIP_UP2
	                            CALL    MOVE_SNAKE2_UP
	                            JMP     NEW_START

	SKIP_UP2:                   
	                            DEC     SNAKE2_FREEZE
	                            JMP     NEW_START
	DOWN2:                      
	                            CMP     SNAKE2_FREEZE,0
	                            JNZ     SKIP_DOWN2
	                            CALL    MOVE_SNAKE2_DOWN
	                            JMP     NEW_START

	SKIP_DOWN2:                 
	                            DEC     SNAKE2_FREEZE
	                            JMP     NEW_START

	RIGHT2:                     
	                            CMP     SNAKE2_FREEZE,0
	                            JNZ     SKIP_RIGHT2
	                            CALL    MOVE_SNAKE2_RIGHT
	                            JMP     NEW_START

	SKIP_RIGHT2:                
	                            DEC     SNAKE2_FREEZE
	                            JMP     NEW_START

	LEFT2:                      
	                            CMP     SNAKE2_FREEZE,0
	                            JNZ     SKIP_LEFT2
	                            CALL    MOVE_SNAKE2_LEFT
	                            JMP     NEW_START

	SKIP_LEFT2:                 
	                            DEC     SNAKE2_FREEZE
	                            JMP     NEW_START

	RETURN_TO_MAIN:             
	                            RET
MOVE_SNAKE ENDP

MOVE_SNAKE_P2 PROC NEAR

	START_MOVE2:                

	                            MOV     AH,1
	                            INT     16h
	                            JZ      LLL
	                            MOV     AH,0
	                            INT     16h
	                            MOV     value,ah
								
	                            CMP     value ,72
	                            JZ      LLL
	                            CMP     value ,80
	                            JZ      LLL
	                            CMP     value,77
	                            JZ      LLL
	                            CMP     value,75
	                            JZ      LLL
	;Check that Transmitter Holding Register is Empty
	                            mov     dx , 3FDH                                             	; Line Status Register
	AGAIN1:                     In      al , dx                                               	;Read Line Status
	                            test    al , 00100000b
	                            JZ      AGAIN1                                                	;Not empty (This line may need to change)
	;If empty put the VALUE in Transmit data register
	                            mov     dx , 3F8H                                             	; Transmit data register
	                            mov     al,VALUE
	                            out     dx , al
	                            cmp     value , 3ch
	                            jz      inline_chat_call
	                            jmp     LLL
	inline_chat_call:           call    inline_chat
	LLL:                        
	; CMP  END_OF_THE_GAME,0
	; JNZ  RETURN_FROM_THE_FUNC
	;call delete_snakes
	;call delete_for_player2
	                            MOV     AX , CURR_APPLE_INDEX
	                            MOV     TEMP_CURR_APPLE_INDEX , AX
	                            MOV     AX , CURR_FIRE_INDEX
	                            MOV     TEMP_CURR_FIRE_INDEX , AX
	                            MOV     AX , SNAKE_LEN_ARR[0]
	                            MOV     TEMP_SNAKE_LEN_ARR[0],AX
	                            MOV     AX , SNAKE_LEN_ARR[2]
	                            MOV     TEMP_SNAKE_LEN_ARR[2],AX

	                            MOV     CX , 10
	                            MOV     BX , 0
	TEMP_SNAKE1:                
	                            MOV     AX , SNAKE1_X[BX]
	                            MOV     TEMP_SNAKE1_X[BX] , AX
	                            MOV     AX , SNAKE1_Y[BX]
	                            MOV     TEMP_SNAKE1_Y[BX] , AX
	                            MOV     AX , SNAKE2_X[BX]
	                            MOV     TEMP_SNAKE2_X[BX] , AX
	                            MOV     AX , SNAKE2_Y[BX]
	                            MOV     TEMP_SNAKE2_Y[BX] , AX
	                            ADD     BX , 2
	                            LOOP    TEMP_SNAKE1

	                            call    RECEIVE_DATA
	                            cmp     open_chat,1
	                            jz      inline_chat_call2
	                            jmp     ccc
	inline_chat_call2:          call    inline_chat
	ccc:                        
	                            CMP     END_OF_THE_GAME,0
	                            JNZ     RETURN_FROM_THE_FUNC
	;CALL    DRAW_BACK_G
	                            call    DELETE_FOR_PLAYER2
	; mov     bx , init_square_y
	; mov     dx , init_square_x
	; mov    player1_score , bx

	; mov     ah , temp_color
	; call    DRAW_SQUARE

	                            CALL    PRINT_TIME2
	                            CALL    DRAW_APPLE
	                            CALL    DRAW_FIRE
	                            CALL    ONE_IS_FREEZED
	                            CALL    TWO_IS_FREEZED
	                            CALL    print_score_player1
	                            CALL    print_score_player2

	                            CALL    DRAW_SNAKES
	                            MOV     CX,0000H
	                            MOV     DX,00FFH
	                            MOV     AH,86H
	                            INT     15H


	                            JMP     START_MOVE2
	; 18 SNAKE1_X
	; 18 SNAKE1_Y
	; 18 SNAKE2_X
	; 18 SNAKE2_Y
	; 4 LEN_ARR
	; 2 SCORE1
	; 2 SCORE2
	; 2 SECONDS
	; 2 MINS
	; 2 INDEX_FIRE
	; 2 INDEX_APPLE
	; 2 SNAKE1_HEAD_DIR
	; 2 SNAKE2_HEAD_DIR
	; DRAW SNAKE 1
	; DRAW SNAKE 2
	; DRAW APPLE
	; DRAW FIRE
	; DRAW TIME
	; DRAW SCORE



	RETURN_FROM_THE_FUNC:       
	                            RET
MOVE_SNAKE_P2 ENDP
inline_chat proc near                                                                      		;;;;;;;;;;;;;;;;;;;;;;;;to do inline chat
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;clear the area to write;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	begin_again:                 
	                             mov     cx,900
	                             mov     dx,1500h
	clear_area:                  mov     bh,0
	                             mov     ah,02h
	                             int     10h
    
	;score of player 1
	                             mov     bl,0                                                  	;color
	                             mov     al,0
	;  add  al,2eh
	                             mov     ah,0eh                                                	;
			
	                             int     10h
	                             inc     dx
	                             loop    clear_area
	;HORIZONTAL
	                             mov     ah,0CH
	                             MOV     CX,640
	LP:                          
	                             CMP     CX,320
	                             JL      CHANGE_COLOR
	                             MOV     AL,02H
	                             JMP     COLOR_CHANGED
	CHANGE_COLOR:                
	                             MOV     AL,05H
	COLOR_CHANGED:               
	                             MOV     BH,0
	                             MOV     DX,335                                                	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	                             INT     10H
	                             LOOP    LP

	;HORIZONTAL
	                             mov     ah,0CH
	                             MOV     CX,640
	LP2:                         
	                             CMP     CX,320
	                             JL      CHANGE_COLOR2
	                             MOV     AL,02H
	                             JMP     COLOR_CHANGED2
	CHANGE_COLOR2:               
	                             MOV     AL,05H
	COLOR_CHANGED2:              
	                             MOV     BH,0
	                             MOV     DX,350                                                	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	                             INT     10H
	                             LOOP    LP2

	;VERTICAL
	                             MOV     AH,0CH
	                             MOV     DX,335
	LP3:                         
	                             MOV     CX,320
	                             MOV     BH,0
	                             MOV     AL,07H
	                             INT     10H
	                             INC     DX
	                             CMP     DX,400
	                             JNZ     LP3


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;print_name1



	                             mov     si,offset name_s2+4
	
	                             mov     dx,1500h
	                             mov     bl , 5
	                             call    player_p
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;print_name2
	                             mov     si,offset name_s+4
	                             mov     dx,152ch
	                             mov     bl , 2
	                             call    player_p

	
	
	;  mov  ah,0
	; int  16h
	                             mov     counter_chat,0
	                             mov     counter_chat2,0

	                             mov     inc_dh,0
	                             mov     inc_dh2,0

	inf2:                        


	            

	                             cmp     counter_chat2,35


	                             jnz     check_next_area
	                             cmp     inc_dh2,2
	                             jnz     cont_inc
	                             jmp     begin_again

	
	cont_inc:                    inc     inc_dh2
	                             mov     counter_chat2,0



	check_next_area:             cmp     counter_chat,35
	                             jnz     con

	                             cmp     inc_dh,2
	                             jnz     inc_positions
	                             jmp     begin_again
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	                           


    
	;score of player 1

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	inc_positions:               inc     inc_dh
	                             mov     counter_chat,0

	con:                                                                                       	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;scrolling

	; mov     ah, 7
	; mov     al, 0
	; mov     cx, 1600h
	; mov     dh, 4fh
	; mov     dl, 18h
	; mov     bh, 12h
	; int     10h

	; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; cmp player_num ,1
	; jz P_is_1
	                             mov     ah,2
	                             mov     bh , 0
								
	                             cmp     player_num ,1

	                             jz      P_is_1
	                             mov     dx,1600h
	                             add     dh,inc_dh
	                             add     dl,counter_chat
	                             jmp     end_of_setup
	P_is_1:                      
	                             mov     dx,162ch
	                             add     dh,inc_dh2
	                             add     dl,counter_chat2
	end_of_setup:                
	
	                             int     10h

	;jmp s_p_is_1
	;;;;;;;;;;if press key
	; P_is_1:
	; mov     ah,2
	;                             mov     bh , 0
	;                             mov     dx,162ch
	; 							add     dh,inc_dh
	;                             add     dx,counter_chat
								  
	                           
	; s_p_is_1:
	                             mov     ah,1
	                             int     16h
	                             jz      re2
	                             mov     ah,0
	                             int     16h
	; cmp al,1bh ;ESC key
	  
	; jz exit2
	;;;;;;;;;;;;;;printing
	                             mov     ah,2
	                             mov     dl,al
	                             mov     VALUE,al

	                             cmp     value,1bh
	                             jz      exit3
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;backspace;;;;;;;;;;;;;;;;;;;;;


	;int 21h
	;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;
	                        

	not_backspace_in_inlinechat: 


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	                             mov     ah,09
	                             mov     bh,0
	                             mov     al,value
	                             mov     cx,1h
	                             mov     bl,3
	                             int     10h
	                             cmp     player_num ,1
	                             jz      P_is_1_inc_counter
	                             inc     counter_chat
	                             jmp     skip1
	p_is_1_inc_counter:          
	                             inc     counter_chat2
	skip1:                       
	;;;;;;;;;;;;;;;;;;;;;;;;
	                             mov     dx , 3FDH                                             	; Line Status Register
	AGAIN2:                      In      al , dx                                               	;Read Line Status
	                             test    al , 00100000b
	                             JZ      AGAIN2

	;If empty put the VALUE in Transmit data register
	                             mov     dx , 3F8H                                             	; Transmit data register
	                             mov     al,VALUE
	                             out     dx , al
	;;;;;;;;;;;;;;;;;;;transmit
	;;;;;;;set cursor





	;;;;;;;;;;;;;;;;;;;
	re2:                         

	;Check that Data is Ready
	                             mov     dx , 3FDH                                             	; Line Status Register
	                             in      al , dx
	                             test    al , 1
	                             JZ      CK2                                                   	;Not Ready
	;If Ready read the VALUE in Receive data register
	                             mov     dx , 03F8H
	                             in      al , dx
	                             mov     VALUE , al
	                             cmp     value , 1bh
	                             jz      exit3
	                             cmp     player_num ,1
	                             jz      is_p_1_2
	                    
	                             cmp     counter_chat2,35
	                             jnz     con2
	                             Jz      inc_col2
	inc_col2:                    
	                             inc     inc_dh2
	                             mov     counter_chat2,0
	                             jmp     skip2
	is_p_1_2:                    

	                             cmp     counter_chat,35
	                             jnz     con2
	                             Jz      inc_col2_2
	inc_col2_2:                  
	                             inc     inc_dh
	                             mov     counter_chat,0

	skip2:                       


	
	con2:                        
	                             cmp     player_num ,1
	                             jz      P_is_1_r
	                             mov     ah,2
	                             mov     bh , 0
	                             mov     dx,162ch
	                             add     dl,counter_chat2
								  
	                             add     dh,inc_dh2
								
	                             int     10h
	                             jmp     s_p_is_1_r
	; ;;;;;;;;;;if press key
	; P_is_1_2:
	; mov     ah,2
	;                             mov     bh , 0
	;                             mov     dx,1600h
	;                              add     dx,counter_chat2
								  
	;                             add     dh,inc_dh2
	p_is_1_r:                    
	                             mov     ah,2
	                             mov     bh , 0
	                             mov     dx,1600h
	                             add     dl,counter_chat
								  
	                             add     dh,inc_dh
								
	                             int     10h

	s_p_is_1_r:                  

	                             mov     ah,2
	                             mov     al , value
	                             mov     dl,al
									
								
	                             mov     VALUE,al

	;int 21h
	                             mov     ah,09
	                             mov     bh,0
	                             mov     al,value
	                             mov     cx,1h
	                             mov     bl,3

	                             int     10h
	                             cmp     player_num , 1
	                             jz      p_num_1
	                             inc     counter_chat2
	                             jmp     s_p_num_1
	p_num_1:                     
	                             inc     counter_chat
	s_p_num_1:                   
	CK2:                         
	                             jmp     inf2


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	                             mov     ah,0
	                             int     16h


	exit3:                       
	                             mov     open_chat,0
	                             call    DRAW_BACK_G
	                             call    DRAW_APPLE
	                             call    DRAW_FIRE
	                             call    DRAW_SNAKES
	                             mov     ax,0
	                             mov     counter_chat,al
	                             mov     counter_chat2,AL
	                             mov     inc_dh,al
	                             mov     inc_dh2,al
	                             mov     value , 1bh
	                             send
	                             ret
inline_chat endp






END MAIN