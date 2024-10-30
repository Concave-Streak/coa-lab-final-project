.data
prompt: .str "Enter an Integer: "
nl: .str "\n"
heap: .int 0

.text

la $a prompt
jal prints

jal getint
move $1 $fo

li $2 1
li $3 0

while:
    bz $1 done

    add $3 $3 $2
    addi $2 $2 1
    subi $1 $1 1

    br while
done:
    move $a $3
    jal printi

    la $a nl
    jal prints
    jr $0