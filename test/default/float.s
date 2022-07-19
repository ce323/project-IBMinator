main:
        #;;  Set a base address
        lui    $3, 0x1000

        addiu $5, $zero,0x40D0  #;;

        addiu $6, $zero,0x40B0  #;; 
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
        cmp  $ts3,$ts4 #;;
        