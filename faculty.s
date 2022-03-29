.global fakultet
    fakultet:
        STMDB  sp!, {r4, lr}        // Put R4 on the stack incase its used in the main function
        CMP R4, #0                  // See if R4 has the value 0, first iteration it will so jump to start
        BEQ start                   // Jump to start

        SUB R0, R0, #1              // Subtract one from R0 go get decending order
        CMP R0, #0                  // See if R0 is 0, if we reach 0 break the loop
        BEQ finished                // If above is true, go to finish
        MUL R4, R0, R4              // Multiply R0 and R4 and store it in R4
        B fakultet                  // Recursive call until codition is met

    start:
        MOV R4, R0                  // Initilize R4 with the value of R0
        B fakultet                  // Go back to where we came from

    finished:
        MOV R0, R4                  // If finished, save the result in R0(we always want the result in R0)
        LDMIA  sp!, {r4, pc}        // Remove r4 from the stack and return to the next row from where we entered fakultet

.global main
    main:
        MOV R0, #5                  // Initilize what faculty you want
        BL fakultet                 // Go into fakultet "function"


