.data
arguments: .arr {15,9}
result:        .int 0      # Store result

.text
la $a arguments
li $3 456
jal booth_mul
move $d $fo
st $d result
halt

booth_mul: #arguments expected in $a[1] and $a[2], result on fo
    #save register values
    subi $sp $sp 5
    st $ra 0($sp)
    st $1 1($sp)
    st $2 2($sp)
    st $3 3($sp)
    st $4 4($sp)
    st $5 5($sp)

    # Load values
    ld $1 0($a)   # 1 = BR
    ld $2 1($a)     # 2 = QR
    li $3 0             #3 = A
    li $4 8            #4 = SC

    booth_loop:
        srl $5 $2 $4 #Qn+1Qn in 5
        bz $5 ashr
        subi $c $5 11
        bz $c ashr

        subi $c $5 01
        bz $c booth_sub
    booth_add:
        add $3 $3 $1
        br ashr
    booth_sub:
        sub $3 $3 $1
        br ashr
    ashr:
        srai $3 $3 1
        srai $2 $2 1
        subi $4 $4 1
        bmi $4 booth_done
        br booth_loop
    booth_done:
        move $fo $3

        ld $ra 0($sp)
        ld $1 1($sp)
        ld $2 2($sp)
        ld $3 3($sp)
        ld $4 4($sp)
        ld $5 5($sp)
        addi $sp $sp 5
        
        jr $ra



