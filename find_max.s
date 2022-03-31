/*******************************************************************
Labb 2.2 - Skriv en funktion i assembler
*******************************************************************/
.data
    numbers:
        .word 1
        .word 3
        .word 5
        .word 7
        .word 9
        .word 8
        .word 6
        .word 4
        .word 2
        .word 0
    title: 
        .asciz " Lab1 , Assignment 2\ n "
    max: 
        .asciz " The max is % d \ n "
    done: 
        .asciz " Done \ n "

.text
.global main
    main:
        MOV R0, #0x0
        BL findMax
        B stop
/*******************************************************************
Function finding maximum value in a zero terminated integer array
*******************************************************************/

.text
findMax:
    STMDB  sp!, {R4, lr}
    B start 
        
    start:
        MOV R1, #0x0 
        LDR R4, =numbers   

    again:
        LDR R2, [R4]  
        CMP R2, #0x0
        BEQ end
            
        CMP R1, R2
        BGT gt

        MOV R1, R2
        ADD R4, R4, #0x4
        B again
            
    gt:
        MOV R1, R1
        ADD R4, R4, #0x4
        B again

    end:
        MOV R0, R1
        LDMIA  sp!, {R4, pc}
    

.text
stop:
    .end
