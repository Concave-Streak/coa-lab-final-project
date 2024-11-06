.data
prompt: .str "Enter size: "
promptn: .str "Enter number: "
prompts: .str "sorted array: "
nl: .str "\n"
args: .arr {0,0}
myarr: .int 0

.text

la $a prompt
jal prints

jal getint
move $1 $fo

la $a args
st $1 1($a)

li $2 0

inploop:
    bz $1 endloop
    
    la $a promptn
    jal prints

    jal getint
    st $fo myarr($2)
    subi $1 $1 1
    addi $2 $2 1
    br inploop
endloop:

la $a args
la $1 myarr
st $1 0($a)

jal insertion_sort

jal print_arr

jr $0

insertion_sort:
    subi $sp $sp 3
    st $ra 0($sp)
    st $1 1($sp)
    st $2 2($sp)

    ld $1 0($a)
    ld $2 1($a) #n

    li $3 1 #i

    floop:

        slt $c $3 $2
        bz $c endfloop
        add $4 $1 $3
        ld $4 0($4) #$4 is key
        subi $5 $3 1 #$5 is j

        wloop:
            sgti $c $5 -1
            bz $c endwloop
            add $6 $1 $5
            ld $6 0($6)
            sgt $c $6 $4
            bz $c endwloop

            addi $7 $5 1
            add $7 $7 $1

            st $6 0($7)

            subi $5 $5 1

            br wloop
        endwloop:

        addi $7 $5 1
        add $7 $7 $1

        st $4 0($7)

        addi $3 $3 1

        br floop
    endfloop:
    
    ld $ra 0($sp)
    ld $1 1($sp)
    ld $2 2($sp)
    addi $sp $sp 3

    jr $ra



print_arr: 
    subi $sp $sp 3
    st $ra 0($sp)
    st $1 1($sp)
    st $2 2($sp)


    ld $1 0($a)
    ld $2 1($a) #n

    outloop:
        bz $2 endoutloop

        ld $a 0($1)
        jal printi

        la $a nl
        jal prints

        addi $1 $1 1
        subi $2 $2 1

        br outloop
    endoutloop:
        ld $ra 0($sp)
        ld $1 1($sp)
        ld $2 2($sp)
        addi $sp $sp 3

        jr $ra


