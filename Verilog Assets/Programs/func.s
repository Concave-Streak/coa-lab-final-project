.text
li $1 10
li $2 42
jal func
move $d $fo
add $4 $1 $2
halt

func:
    sub $fo $1 $2
    add $fo $1 $fo
    jr $ra

