data_reg = 4097
cmd_reg = 4096

.data
starttext: .str "Welcome to dasmon !\nC to clear screen, R to run your program \nEnter your program in hexadecimal below: \n"
prompt: .str ":$>"
nl: .str "\n"
clear: .arr {27,91,50,74,27,91,72,0}
end: .int 0

.text

la $a starttext
jal prints

la $9 end

mainloop:

    move $a $9
    jal printi

    la $a prompt
    jal prints

    li $1 0

    instloop:    
        jal getchar
        subi $c $fo 58
        bz $c view
        subi $c $fo 10
        bz $c saveinst
        subi $c $fo 67
        bz $c clrsrc
        subi $c $fo 82
        bz $c run
        subi $c $fo 96
        bpl $c alpha
        subi $c $fo 47
        bpl $c num
    alpha:
        subi $fo $fo 87
        br addinst
    num:
        subi $fo $fo 48
    addinst:
        slai $1 $1 4
        add $1 $1 $fo
        br instloop
    saveinst:
        st $1 0($9)
        addi $9 $9 1
        br mainloop

view:
    jal getint
    ld $a 0($fo)
    jal printi
    la $a nl
    jal prints
    br mainloop

clrsrc:
    la $a clear
    jal prints
    br mainloop

run: 
    la $a clear
    jal prints

    la $ra end
    jr $ra



booth_mul: #arguments expected in 0($a) and 1($a), return value on $fo

    subi $sp $sp 7
    st $ra 0($sp)
    st $1 1($sp)
    st $2 2($sp)
    st $3 3($sp)
    st $4 4($sp)
    st $5 5($sp)
    st $6 6($sp)
    
    ld $1 0($a)    #multiplicand
    ld $2 1($a)    #multiplier
    
    li $3 0               # Clear register $3 (Accumulator) to store partial results
    li $4 32           # Set bit counter for 32 iterations ($4)
    li $5 0               # Initialize the previous bit ($5) to 0 (prev LSB of R2)

    booth_loop:
        andi $6 $2 1               # Extract LSB of multiplier (R2)
        sub $6 $6 $5               # Compare current LSB with previous bit (stored in $6)
        
        bz $6 booth_shift                 # If no change (i.e., 00 or 11), skip addition/subtraction
        bpl $6 booth_sub            # If 01 (prev bit = 0, current bit = 1), go to booth_add
        bmi $6 booth_add            # If 10 (prev bit = 1, current bit = 0), go to booth_sub

    booth_add:
        add $3 $3 $1               # Add multiplicand to the accumulator (R3 += R1)
        br booth_shift

    booth_sub:
        sub $3 $3 $1               # Subtract multiplicand from the accumulator (R3 -= R1)

    booth_shift:
        andi $5 $2 1               # Set $5 to new LSB of multiplier (to track changes in next iteration)

        andi $6 $3 1               # Extract the LSB of accumulator (R3)
        srai $3 $3 1               # Shift accumulator (R3) right (R3 >>= 1)
        srli $2 $2 1               # Shift multiplier (R2) right (R2 >>= 1)

        slai $6 $6 31               #shift lsb of accumulator to make msb of multiplier
        or $2 $2 $6                # Shift LSB of accumulator into MSB of multiplier (R2 |= LSB of R3)

        subi $4 $4 1                     # Decrement the counter ($6--)    
        bz $4 booth_end                  # If counter reaches 0, booth_end the loop
        br booth_loop              # Repeat the loop

    booth_end:
        move $fo $2
        ld $ra 0($sp)
        ld $1 1($sp)
        ld $2 2($sp)
        ld $3 3($sp)
        ld $4 4($sp)
        ld $5 5($sp)
        ld $6 6($sp)
        addi $sp $sp 7
        jr $ra


prints: #expects string pointer in $a
    ld $c 0($a)
    bz $c print_done
    
    st $c data_reg
    li $c 1
    st $c cmd_reg
    addi $a $a 1

    print_wait:
        ld $c cmd_reg
        bz $c prints
        br print_wait 
    print_done:
        jr $ra


printc:
    st $a data_reg
    li $c 1
    st $c cmd_reg
    printc_wait:
        ld $c cmd_reg
        bz $c printc_done
        br printc_wait
    printc_done:
        jr $ra


printi:
    st $a data_reg
    li $c 3
    st $c cmd_reg
    printi_wait:
        ld $c cmd_reg
        bz $c printi_done
        br printi_wait
    printi_done:
        jr $ra


getchar: #returns getut on $fo
    li $c 2
    st $c cmd_reg
    getchar_wait:
        ld $c cmd_reg
        bz $c getchar_done
        br getchar_wait
    getchar_done:
        ld $fo data_reg
        jr $ra

getint:
    subi $sp $sp 2
    st $1 0($sp)
    st $2 1($sp)

    li $fo 0 #accumulator

    getintloop:
        li $c 2
        st $c cmd_reg
        getint_wait:
            ld $c cmd_reg
            bz $c int_rec
            br getint_wait
        int_rec:
            ld $c data_reg

            subi $c $c 10
            bz $c getint_done

            subi $c $c 38
            slai $1 $fo 1
            slai $2 $fo 3
            add $fo $1 $2

            add $fo $fo $c

            br getintloop
    getint_done:
            ld $1 0($sp)
            ld $2 1($sp)
            addi $sp $sp 2
            jr $ra
