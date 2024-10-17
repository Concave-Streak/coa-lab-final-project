.data
a: .int 100
b: .int 0

.text
ld $1 a($0)

li $2 -3
li $3 10

while:
    bz $3 done
    add $1 $1 $2
    subi $3 $3 1
    br while
done:
    st $1 b($0)
    halt