# Wtitten by Jakob Adamsson and Emil Gullbrandsson
# Program finished 4/19/2022 3:26 PM
# For the course Datorteknik, DV1493 at BTH


.data
headMsg:.asciz	"Start av testprogram. Skriv in 5 tal!"
endMsg:	.asciz	"Slut på testprogram!"
buf:	.space	64
sum:	.quad	0
count:	.quad	0
temp:	.quad	0

inBuf: .space 64
inPos: .quad 0
outBuf: .space 64
outPos: .quad 0

.text
.global	main
main:
	pushq	$0
	movq	$headMsg,%rdi
	call	putText
	call	outImage
	call	inImage
	movq	$5,count
l1:
	call	getInt
	movq	%rax,temp
	cmpq	$0,%rax
	jge		l2
	call	getOutPos
	decq	%rax
	movq	%rax,%rdi
	call	setOutPos
l2:
	movq	temp,%rdx
	add	    %rdx,sum
	movq	%rdx,%rdi
	call	putInt
	movq	$'+',%rdi
	call	putChar
	decq	count
	cmpq	$0,count
	jne	l1
	call	getOutPos
	decq	%rax
	movq	%rax,%rdi
	call	setOutPos
	movq	$'=',%rdi
	call	putChar
	movq	sum, %rdi
	call	putInt
	call	outImage
	movq	$12,%rsi
	movq	$buf,%rdi
	call	getText
	movq	$buf,%rdi
	call	putText
	movq	$125,%rdi
	call	putInt
	call	outImage
	movq	$endMsg,%rdi
	call	putText
	call	outImage
	popq	%rax
	ret

inImage:
    pushq %rdi
    pushq %rsi
    pushq %rdx
    pushq %rax
    movq $0,%rax
    leaq inBuf(%rax), %rdi                                                      # Imediate insert of adress inBuf into rdi
    movq $65, %rsi                                                              # 65-1 symbols accepted(match with inBuf)
    movq stdin, %rdx                                                            # Standardinput as third argument
    call fgets                                                                  # fgets(adress, symbols accepted, stdin)
        
    popq %rax
    popq %rdx
    popq %rsi
    popq %rdi
    movq $0, inPos
    ret

outImage:
    pushq %rdi
    pushq outBuf
    movq $0,outPos                                                              # Reset outPos since a subrutine made the buffert full
    call getOutPos                                                              # Load the new position int 
    leaq outBuf(%rax),%rdi                                                      # Move letter at index %rax from outBuf to rdi  						                                     
    call puts	                                                                # To use puts, have the value you want to show in rdi
    movq $0, outPos
    popq outBuf
    popq %rdi
    ret

getOutPos:
    movq outPos,%rax
    ret

getInPos:
    movq inPos,%rax
    ret
    
makePositive:
    negq %rdi                                                                   # If negative, make it positivt inorder to turn it into ascii
    movq $1,%rcx                                                                # Flag rcx with 1 for a check later
    jmp putIntRec


putInt:
    pushq %r8                                                                         
    pushq %rcx                                                                  
    pushq %rdx                                                                  
    movq $0,%r8                                                        
    cmpq $0,%rdi                                                                
    jl makePositive

    putIntRec:
        incq %r8                                                            
        movq $0,%rdx                                                                                                                   
        movq %rdi,%rax                                                                                                          
        movq $10,%rdi                                                           
        divq %rdi                                                       
        pushq %rdx                                                                                                                      
        movq %rax,%rdi                                                          
        cmpq $0,%rax                                                                                                                 
        jne putIntRec
        call getOutPos                                                          
        cmpq $1, %rcx                                                           
        jne putIntRec2
        movq $'-', %rdi
        movq %rdi, outBuf(%rax)
        incq %rax
  
    putIntRec2:
        popq %rdi                                                                                                                        
        addq $'0',%rdi                                                          
 
        movq %rdi,outBuf(%rax)                                              
        incq %rax
        decq %r8                                                                
        cmpq $0,%r8 
        jne putIntRec2
        movq %rax,outPos
        popq %rdx
        popq %rcx
        popq %r8
        ret

toImagefromgetInt:
    call inImage
    jmp readInt
    
getInt:
    pushq %rdi
    pushq %rsi
    call getInPos
    leaq inBuf(%rax),%rdi
    cmpq $0, (%rdi)
    je toImagefromgetInt
    cmpq $64,%rax
    je toImagefromgetInt

    readInt:
        call getInPos
        leaq inBuf(%rax),%rdi                                                   # Load int at index rax into rdi
        movq $0, %rsi                                                           # Retur
        movq $0, %r11                                                           # Teckenindikator (0 = positivt tal)
        
    lBlancCheck:
        cmpb $' ', (%rdi)                                                                                                        
        jne lSignPlus                                                           
        incq %rdi 
        incq %rax

        jmp lBlancCheck
    
    lSignPlus:
        cmpb $'+', (%rdi)  
        jne lSignMinus  
        incq %rdi 
        incq %rax

        jmp lNumber 
    
    lSignMinus:
        cmpb $'-', (%rdi) 
        jne lNumber  
        movq $1, %r11  
        incq %rdi  
        incq %rax
        
    lNumber:
        cmpb $'0', (%rdi)  
        jl lNAN # 
        cmpb $57, (%rdi)  
        jg lNAN # 
        movzbq (%rdi), %r10 
        subq $'0', %r10 
        imulq $10, %rsi  
        addq %r10, %rsi 
        incq %rdi 
        incq %rax
        jmp lNumber  
    
    lNAN:
        incq %rax
        cmpq $1, %r11 
        jne lEnd 
        negq %rsi 
        
    lEnd:
    
        movq %rax,inPos
        movq %rsi,%rax
        popq %rsi
        popq %rdi
        ret

    toImageFromChar:
        call inImage
        jmp getChar2

getChar:
    pushq %rdi
    call getInPos
    cmpq $64, %rax
    jg toImageFromChar
    cmpq $0, %rax
    jle toImageFromChar
    
    getChar2:
        leaq inBuf, %rdi
        movzbq (%rdi, %rax), %rcx
        movq %rcx, %rax
        incq inPos
        popq %rdi
        ret
        
tooutImagefromChar:
    call outImage
    jmp putChar

putChar:
    call getOutPos
    cmpq $64, %rax
    jg outImage
    movq %rdi, outBuf(%rax)
    incq outPos
    ret


setInPos:
    cmpq $64, %rdi
    jg setMaxInPos
    
    cmpq $0, %rdi
    jle setMinInPos
    movq %rdi, inPos
    
    endSetInPos:
        ret

    setMaxInPos:
        movq $64, inPos
        jmp endSetInPos
    
    setMinInPos:
        movq $0, inPos
        jmp endSetInPos

setOutPos:
    cmpq $64, %rdi
    jg setMaxOutPos
    
    cmpq $0, %rdi
    jle setMinOutPos
    movq %rdi, outPos
    
    endSetOutPos:
        ret

    setMaxOutPos:
        movq $64, outPos
        jmp endSetOutPos
    
    setMinOutPos:
        movq $0, outPos
        jmp endSetOutPos
    
getText:
    pushq %r8
    pushq %rcx
    pushq %rsi

    xorq %r8, %r8
    call getInPos

    getTextRec:
        cmpq $64, %rax
        jg end
        
        movb inBuf(%rax), %cl
        movb %cl, (%rdi, %r8)
        incq %r8
        incq %rax
        incq inPos

        cmpq %rsi,%r8
        jl getTextRec 

        cmpq %r8, %rsi
        jg end

    end:
        movq %r8, %rax
        popq %rsi
        popq %rcx
        popq %r8
        ret


toOutImagefromPutText:
    call outImage
    jmp endPutText
    
putText:
    pushq %r8
    pushq %rcx
    pushq %rax
    xorq %r8, %r8
    call getOutPos
    putTextRec:
        
        movzbq (%rdi,%r8), %rcx
        cmpq $0,%rcx
        je endPutText
        movb %cl, outBuf(%rax)
        
        incq %r8
        incq %rax
        
        cmpq $64, %rax
        jl putTextRec
        jmp toOutImagefromPutText
    
 
    endPutText:
        movq %rax, outPos
        popq %rax
        popq %rcx
        popq %r8
        leaq outBuf,%rdi
        ret

