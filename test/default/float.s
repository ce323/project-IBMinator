main:
        #;;  Set a base address
        lui   $3, 0x1000
        addiu $5, $zero,0x40D0  #;; num = 5.5
        addiu $6, $zero,0x40B0  #;; num = 6.5

        nop
        nop
        nop

        sw  $5, 0($3) #;;
        sw  $6, 4($3) #;;
        lws $ts1, 0($3) #;;
        lws $ts2, 4($3) #;;

        nop
        nop
        nop

        adds $ts3,$ts1,$ts2 #;;
        subs $ts4,$ts2,$ts1 #;;
        divs $ts5,$ts2,$ts1 #;;
        muls $ts6,$ts2,$ts1 #;;
        cmp  $ts1,$ts2 #;;
        revs $ts7,$ts1 #;;
        rnds $ts8,$ts1 #;;

        nop
        nop
        nop
        nop
        
        sws $ts3, 0($3) #;;
        sws $ts4, 4($3) #;;
        sws $ts5, 8($3) #;;
        sws $ts6, 12($3) #;;
        sws $ts7, 16($3) #;;
        sws $ts8, 20($3) #;;

        nop
        nop
        nop
        nop

        lw $9 , 0($3) #;;
        lw $10, 4($3) #;;
        lw $11, 8($3) #;;
        lw $12, 12($3) #;;
        lw $13, 16($3) #;;
        lw $14, 20($3) #;;
        
        syscall