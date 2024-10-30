.data
dividend: .int 100
divisor: .int 2

.text
    li $1 0             # $1 = accumulator
    li $2 31            # $2 = iteration count
    ld $3 divisor($0)   # $3 = divisor (M)
    ld $fo dividend($0)  # $4 = dividend (to be divided)
    # li $fo 0            # $fo = quotient

loop:
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
    andi $fo $fo 2147483648
    halt
