.data
arguments: .arr {65, 387}
result: .int 0                # Placeholder for result

.text
la $a arguments
jal booth_mul
move $d $fo
st $d result
halt

booth_mul: #arguments expected in 0($a) and 1($a), return value on $fo, overflow on $c

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
