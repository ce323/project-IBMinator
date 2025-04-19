        .text
main:
    #;;  Set a base address
    lui $3, 0x0000
    lui $5, 0x40E0  #;; num = 7
    lui $6, 0x4050  #;; num = 3.25
    nop
    nop
    nop
    sw $5, 0($3) #;; 
	nop
	nop
	nop
    sw $6, 4($3) #;; store 6.5 in memory
    lws $ts1, 0($3) #;; load 7 from memory in coprocessor register
    lws $ts2, 4($3) #;; load 3.25 from memory in coprocessor register
    nop
    nop
    nop
	cmp $ts1, $ts2 #;; 
    divs $ts5, $ts31, $ts30 #;; 
    rnds $ts5, $ts5 #;;
    nop
    nop
    nop
    nop
    sws $ts5, 0($3) #;;
    nop
    nop
    lw $9, 0($3) #;;
	nop
	nop
	syscall
	nop