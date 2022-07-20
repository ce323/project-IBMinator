        .text
main:
        #;;  Set a base address
        lui   $3, 0x1000
        lui $5, 0x40D0  #;; num = 5.5
        lui $6, 0x40B0  #;; num = 6.5

        nop
        nop
        nop

        sw  $5, 0($3) #;; store 5.5 in memory
        sw  $6, 4($3) #;; store 6.5 in memory
        lws $ts1, 0($3) #;; load 5.5 from memory in coprocessor register
        lws $ts2, 4($3) #;; load 6.5 from memory in coprocessor register

        nop
        nop
        nop

        adds $ts3,$ts1,$ts2 #;; add 5.5 and 6.5
        subs $ts4,$ts2,$ts1 #;; subtract 6.5 from 5.5
        divs $ts5,$ts2,$ts1 #;; divide 6.5 from 5.5
        muls $ts6,$ts2,$ts1 #;; multiply 6.5 and 5.5
        cmp $ts1,$ts2 #;; compare 5.5 and 6.5
        revs $ts7,$ts1 #;; reverse 5.5
        rnds $ts8,$ts1 #;; round 5.5

        nop
        nop
        nop
        nop
        
        sws $ts3, 0($3) #;; store 5.5+6.5 in memory
        sws $ts4, 4($3) #;; store 6.5-5.5 in memory
        sws $ts5, 8($3) #;; store 6.5/5.5 in memory
        sws $ts6, 12($3) #;; store 6.5*5.5 in memory
        sws $ts7, 16($3) #;; store 1/5.5 in memory
        sws $ts8, 20($3) #;; store 6

        nop
        nop
        nop
        nop

        lw $9 , 0($3) #;; load 5.5+6.5 from memory in register $9
        lw $10, 4($3) #;; load 6.5-5.5 from memory in register $10
        lw $11, 8($3) #;; load 6.5/5.5 from memory in register $11
        lw $12, 12($3) #;; load 6.5*5.5 from memory in register $12
        lw $13, 16($3) #;; load 1/5.5 from memory in register $13
        lw $14, 20($3) #;; load 6 from memory in register $14
        
        syscall