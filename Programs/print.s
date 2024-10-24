cmd_reg = 4096
data_reg = 4097

.data
mystr: .str "Hello, World\n"
greet: .str "Good Morning!\n"

.text

main:

    li $1 42
    li $2 98
    la $a mystr
    jal printstr

    la $a greet
    jal printstr

    jal getchar
    move $d $fo

    move $a $d
    jal printchar

    jal getint
    move $d $fo

    halt


printstr: #expects string pointer in $a
    ld $c 0($a)
    bz $c print_done
    
    st $c data_reg
    li $c 1
    st $c cmd_reg
    addi $a $a 1

    print_wait:
        ld $c cmd_reg
        bz $c printstr
        br print_wait 
    print_done:
        jr $ra


printchar:
    st $a data_reg
    li $c 1
    st $c cmd_reg
    printchar_wait:
        ld $c cmd_reg
        bz $c printchar_done
        br printchar_wait
    printchar_done:
        jr $ra


getchar: #returns getut on $fo
    li $c 2
    st $c cmd_reg
    getchar_wait:
        ld $c cmd_reg
        bz $c getchar_done
        br getchar_wait
    getchar_done:
        ld $fo data_reg
        jr $ra

getint:
    subi $sp $sp 2
    st $1 0($sp)
    st $2 1($sp)

    li $fo 0

    getintloop:
        li $c 2
        st $c cmd_reg
        getint_wait:
            ld $c cmd_reg
            bz $c int_rec
            br getint_wait
        int_rec:
            ld $c data_reg

            subi $c $c 10
            bz $c getint_done

            subi $c $c 38
            slai $1 $fo 1
            slai $2 $fo 3
            add $fo $1 $2

            add $fo $fo $c

            br getintloop
    getint_done:
            ld $1 0($sp)
            ld $2 1($sp)
            addi $sp $sp 2
            jr $ra