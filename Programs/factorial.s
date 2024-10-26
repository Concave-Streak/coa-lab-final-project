.data
prompt: .str "Enter a Number: "
output: .str "The factorial is: " 
nl: .str "\n"
args: .arr {0, 0}
clear: .arr {27,91,50,74,27,91,72,0}

.text

main:

    li $d 16
    
    la $a prompt
    jal prints

    li $d 32

    jal getint

    li $d 48

    move $a $fo
    jal factorial
    move $d $fo

    li $d 64

    la $a output
    jal prints

    move $a $d
    jal printi

    la $a nl
    jal prints

    la $a clear
    jal prints

    li $d 80

    br main


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