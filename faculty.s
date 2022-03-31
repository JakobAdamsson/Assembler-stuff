faculty:
    STMDB  sp!, {r4, lr}                /* Put register 4 and the last possition in the program on the stack */
    CMP R4, #0                          /* Register 4 is 0 by default, change it accordingly in START */
    BEQ start                           /* Branch Equal meaning the above comparison, go to start */

    SUB R0, R0, #1                      /* Subtract the value within register 0 to achieve decending order */
    CMP R0, #0                          /* Check if we reach 0 */
    BEQ finished                        /* If 0 is reached, the comparison above is true, go to finish */
    MUL R4, R0, R4                      /* If not 0, multiply R0 and R4 and store in R4 */
    B faculty                           /* Call recursive */

    start:
        MOV R4, R0                      /* Copy the value of R0 to R4, being the value in numbers array */
        B faculty                       /* Go back to faculty */

    finished:
        MOV R0, R4                      /* If R0 reached 0, save result in R0 */
        LDMIA  sp!, {r4, pc}            /* Since the faculty is calculated, remove r4 and last current possition from the stack, going to current program pointer */

.global main
    main:
        LDR R0, =title                  /* Load title adress to R0 */
        SWI 0x02                        /* Syscall to print string to screen */
        LDR R3, =numbers                /* Save numbers adress in R3 */
        LDR R2, [R3]                    /* Grab first value of R3, store it in R2 */
        MOV R0, R2                      /* Copy R2 to R0(Using R0 in faculty rutine) */         
        
    loop:
        CMP R2, #0x0                    /* If we reach the last item in numbers, exit program */
        BEQ end                         /* Go to end */
        BL faculty                      /* Go to faculty */
        BL print                        /* Go to print */
        B update
    
    update:
        ADD R3, R3, #0x04               /* Adding 4 bytes to R4 inorder to travel the numbers array */
        LDR R2, [R3]                    /* Load the new number from R3, after adding 4 bytes to R2 */
        MOV R0, R2                      /* Move the new value from R2 to R0 */
        MOV R4, #0x0                    /* Nulls R4 to avoid any errors */
        B loop                          /* Call recursive */      
    
end:
    SWI 0x11                            /* Syscall EXIT */

print:
    /* Prints the text and \n */
    MOV R1, R0                          /* Save value to be printed in R1 */
    LDR R0, =newline                    /* Load adress of newline to R1 */
    SWI 0x02                            /* Syscall "Display string on Stdout" */
    
    /* Prints the integers */
    MOV R0, #0x1                        /* File handle so i can print integer to screen */
    SWI 0x6b                            /* Syscall Write integer to file */
    BX lr                               /* Go back to where we came from, being +1 from BL print */

.data
numbers:
    .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0
newline:
    .asciz "\n" 
title:
    .asciz "Faculty of 1-10:"
