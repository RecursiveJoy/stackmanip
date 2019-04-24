.data
    multiplicand: .asciiz "Enter a multiplicand."
    multiplier: .asciiz "Enter a multiplier."
    product: .asciiz "The product is "



.text
.globl main
main: 

	#prompt for multiplicand
	la $a0, multiplicand
	li $v0, 4
	syscall
	
	#get multiplicand, move to $a1
        li $v0, 5
        syscall
        move $a1, $v0
        
        #prompt for multiplier
	la $a0, multiplier
	li $v0, 4
	syscall
	
	#get multiplier, move to $a2
        li $v0, 5
        syscall
        move $a2, $v0
        
        #move values to correct registers
        move $a0, $a1
        move $a1, $a2
        
        ifzero:
        	beq $a0, $zero, true
		bne $a1, $zero, false
        
        true:
	        #prompt introduces the product:
		la $a0, product
		li $v0, 4
		syscall
	
		#print product
		move $a0, $zero
		li $v0, 1
		syscall
		
		j endif       

        false:
	        #jump and link to the multiply function with $a0 and $a1 full
        	jal multiply
        
	        #move product out of v0 and restore stack pointer.
        	move $t1, $v0
	        addi $sp, $sp, 4        
	
		#prompt introduces the product:
		la $a0, product
		li $v0, 4
		syscall
	
		#print product
		move $a0, $t1
		li $v0, 1
		syscall       

	endif:        
	        #Tell the system the program is done.
        	li $v0, 10
	        syscall

#--------------------------------------------------
# multiply function
#a0: multiplicand
#a1: multiplier
#a2: running product
#v0: product
#--------------------------------------------------

.globl multiply
multiply:
    
    ifbasecase:
    	#prepare stack for four items
        addi $sp, $sp, -12
        
        #store local variables in stack
        sw $ra, 0($sp)
        sw $a0, 4($sp)
        sw $a1, 8($sp)
        
        bne $a1, 1, else 
        
        #base case, when multiplier = 1 add multiplicand to $v0
        add $v0, $a0, $zero
        addi $sp, $sp, -4
        sw $v0, 12($sp)
        jr $ra
        
    else:
 	
 	#otherwise subtract 1 from multiplier and call multiply
	addi $a1, $a1, -1
	jal multiply
	
	#load variables from the stack
	lw $v0, 0($sp)
	lw $ra, 4($sp)
	lw $a0, 8($sp)
	lw $a1, 12($sp)
	
	#restore stack pointer
	addi $sp, $sp, 12
	
	#make room & put v0 on stack
	add $v0, $v0, $a0
	sw $v0, 0($sp)

	jr $ra
