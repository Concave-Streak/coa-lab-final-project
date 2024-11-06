.data
space: .str " "
nl: .str "\n"
prompt: .str "enter dividend: "
prompt2: .str "enter a divisor: "
arguments: .arr {0, 0}
result: .str "The quotient is: "

.text
la $a prompt
jal prints

jal getint
move $1 $fo

la $a prompt2
jal prints

jal getint
move $2 $fo

la $a arguments
st $1 0($a)
st $2 1($a)

jal div_nres
move $d $fo

la $a result
jal prints

move $a $d
jal printi

la $a nl
jal prints

jr $0

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
    

    ld $ra 0($sp)
    ld $1 1($sp)
    ld $2 2($sp)
    ld $3 3($sp)
    ld $4 4($sp)
    addi $sp $sp 5
    jr $ra