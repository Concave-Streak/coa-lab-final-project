.data
starttext: .str "Welcome \n"
prompt: .str "$>"


.text

inploop:
    jal getchar
    move $1 $fo
    subi $