.data
num1:  .int 36 # First number
num2:  .int 60 # Second number

.text
ld $1 num1 # Load num1 into $1
ld $2 num2 # Load num2 into $2

gcd_loop:
    sub $c $1 $2
    bz $c end

    sgt $c $1 $2
    bz $c less_than
    sub $1 $1 $2
    br gcd_loop

less_than:
    sub $2 $2 $1
    br gcd_loop

end:
    move $d $1
    halt

