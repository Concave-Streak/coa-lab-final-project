.data
space: .str " "
nl: .str "\n"
dividend: .int 100
divisor: .int 2

.text
    li $1 0             # $1 = accumulator
    li $2 31            # $2 = iteration count
    
    jal getint
    move $3 $fo

    jal getint
    # li $fo 0            # $fo = quotient

loop:
    move $a $fo
    jal printi

    la $a space
    jal prints

    move $a $1
    jal printi

    la $a nl
    jal prints

    bz $2 endloop

    bmi $1 negCase1
    negCase1:
        slai $fo $fo 1       # Left shift quotient
        slai $1 $1 1         # Left shift accumulator
        srli $4 $fo 31       # Right shift dividend to get Q[n-1] in $4[0]
        add $1 $1 $4         # Combine accumulator with next dividend bit
        add $1 $1 $3         # Add divisor
        br continue1
    
    slai $fo $fo 1          # Left shift quotient
    slai $1 $1 1            # Left shift accumulator
    srli $4 $fo 31          # Right shift dividend to get Q[n-1] in $4[0]
    add $1 $1 $4            # Combine accumulator with next dividend bit
    sub $1 $1 $3            # Subtract divisor

    continue1:

    bmi $1 negCase2      # If accumulator is negative
        ori $fo $fo 1    # Set LSB of quotient
        br continue2
    negCase2:
        ori $fo $fo 0    # Set LSB of quotient
    continue2:

    subi $2 $2 1         # Decrement iteration counter
    br loop

endloop:
    bmi $1 adjustRemainder
    adjustRemainder:
        add $1 $1 $3     # Adjust remainder if accumulator is negative
    slai $fo $fo 1
    srli $fo $fo 1

    move $a $fo
    jal printi

    jr $0
