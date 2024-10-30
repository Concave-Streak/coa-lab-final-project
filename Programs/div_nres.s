.data
space: .str " "
nl: .str "\n"
arguments: .arr {65, 387}
result: .int 0                # Placeholder for result

.text
la $a arguments
jal div_nres
move $d $fo
st $d result
halt

div_nres:               #arguments expected in 0($a) and 1($a), return value on $fo

    subi $sp $sp 5
    st $ra 0($sp)
    st $1 1($sp)
    st $2 2($sp)
    st $3 3($sp)
    st $4 4($sp)
    
    ld $fo 0($a)        # dividend (also the quotient will be stored here)
    ld $3 1($a)         # divisor

    li $1 0             # $1 = accumulator
    li $2 31            # $2 = iteration count

loop:
    ####### debug
    move $a $fo
    jal printi          

    la $a space
    jal prints

    move $a $1
    jal printi

    la $a nl
    jal prints
    ####### debug

    bz $2 endloop

    bmi $1 negCase1
    slai $fo $fo 1          # Left shift quotient
    slai $1 $1 1            # Left shift accumulator
    srli $4 $fo 31          # Right shift dividend to get Q[n-1] in $4[0]
    add $1 $1 $4            # Combine accumulator with next dividend bit
    sub $1 $1 $3            # Subtract divisor
    br continue1

    negCase1:
        slai $fo $fo 1       # Left shift quotient
        slai $1 $1 1         # Left shift accumulator
        srli $4 $fo 31       # Right shift dividend to get Q[n-1] in $4[0]
        add $1 $1 $4         # Combine accumulator with next dividend bit
        add $1 $1 $3         # Add divisor

    continue1:

    bmi $1 negCase2      # If accumulator is negative
    ori $fo $fo 1        # Set LSB of quotient
    br continue2
    negCase2:

    continue2:

    subi $2 $2 1         # Decrement iteration counter
    br loop

endloop:
    bmi $1 adjustRemainder
    br skipAdjustRemainder
    adjustRemainder:
        add $1 $1 $3     # Adjust remainder if accumulator is negative
    skipAdjustRemainder:
    slai $fo $fo 1
    srli $fo $fo 1
    

    move $a $fo         # debug
    jal printi          # debug

    ld $ra 0($sp)
    ld $1 1($sp)
    ld $2 2($sp)
    ld $3 3($sp)
    ld $4 4($sp)
    addi $sp $sp 5
    jr $ra