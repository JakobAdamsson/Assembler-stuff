.data                               // Put all data within .data block
    numbers:                        // "Name" of array
        .word 1, 2, 3, 4, 0         // Declare the array with bytesize(word in this case which is 32 bytes per character)

.text                               // Put all program code within .text block
.global add_array
    add_array:
        STMDB  sp!, {R4, lr}        //  Open Register 4, put it on the stack
        
        LDR R2, [R1]                // Load the first value from R1, that is R1[0]
        CMP R2, #0                  // If we load a zero, that means end of array, go to end section
        BEQ end                     // change branch to end

        ADD R4, R4, R2              // Update the value of register 4
        ADD R1, R1, #4              // Update the pointer within numbers array to next number by adding 4 bytes
        
        B add_array                 // change branch to add_array, doing this recursivly

    start:
        LDR R1, =numbers            // Upon start, jump here and load the memory adress of numbers in register 1
        MOV R0, #0                  // Declare register 0 as the counter 
        B add_array                 // Once all registers are created, go into add_array branch

    end:
        MOV R0, R4                  // Move result in register 0, always want to have result in register 0
        LDMIA  sp!, {r4, pc}        // Remove register 4 from stack, exiting this part of the program

   
.global main        
    main:       
        BL start                    // Change branch to start
        .end                        // quits the program