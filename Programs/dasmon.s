.data
starttext: .str "Welcome to dasmon !\nC to clear screen, R to run your program \nEnter your program in hexadecimal below: \n"
prompt: .str "$>"
clear: .arr {27,91,50,74,27,91,72,0}

.text

la $a starttext
jal prints

la $9 heap

mainloop:
    la $a prompt
    jal prints

    li $1 0

    instloop:    
        jal getchar
        subi $c $fo 10
        bz $c saveinst
        subi $c $fo 67
        bz $c clrsrc
        subi $c $fo 82
        bz $c run
        subi $c $fo 96
        bpl $c alpha
        subi $c $fo 47
        bpl $c num
    alpha:
        subi $fo $fo 87
        br addinst
    num:
        subi $fo $fo 48
    addinst:
        slai $1 $1 4
        add $1 $1 $fo
        br instloop
    saveinst:
        st $1 0($9)
        addi $9 $9 1
        br mainloop

clrsrc:
    la $a clear
    jal prints
    br mainloop

run: 
    la $a clear
    jal prints

    la $ra heap
    jr $ra