.data
prompt: .str "Enter a Number: "
output: .str "The factorial is: " 
args: .arr {0, 0}

.text

main:
    la $a prompt
    jal prints

    jal getint

    move $a $fo
    jal factorial
    move $1 $fo

    la $a output
    jal prints

    move $a $1
    jal printi

    halt


factorial: #argument expected in $a, result in $fo
    subi $sp $sp 3
    st $ra 0($sp)
    st $a 1($sp)
    st $1 2($sp)

    move $fo $a
    subi $c $a 2
    bmi $c factend

    subi $a $a 1
    jal factorial
    
    ld $a 1($sp)
    la $1 args
    st $a 0($1)
    st $fo 1($1)

    move $a $1

    jal booth_mul

    factend:
        ld $ra 0($sp)
        ld $1 2($sp)
        addi $sp $sp 3
        jr $ra