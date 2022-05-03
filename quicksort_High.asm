    .data       # here is data segment
    # TODO: your datas may be held here
    line_sep:    .asciiz "\n" 
    .text       # here is text segment
    .globl main
    # getting input from user
main:

    li $v0, 5
    syscall               
    #   array length
    move $s7, $v0  
    # allocating array size
	sll $s6, $s7, 2   
    
    move $a0,$s6			 
	li $v0, 9                
    syscall
	# pointer of array
	move $s5, $v0

	move $t0, $s5
	
	add $t1, $s5, $s6

    # getting the elements of array
getinputfor:
    bgeu $t0, $t1, endgetinputfor   
    li $v0, 5              		    
    syscall
    sw $v0, 0($t0)  
    addi $t0, $t0, 4
    b getinputfor
endgetinputfor:
	move $a0, $s5 # a0= pointer to the array
	li $a1, 0  		 # a1= first index of array
	addi $a2 ,$s7,-1	# a2= last index of array  
    jal quicksort           #jump to quicksort 
	sll $t7,$s7,2
	add $t7,$t7,$a0
	move $t0,$a0
printfor:
    bgeu $t0, $t7, endprintfor # if reached end stop the loop
    lw $a0, 0($t0)
    li $v0, 1               # for printing integer
    syscall
    li $v0, 4
    la $a0, line_sep
    syscall
    addi $t0, $t0, 4 # add to the pointer
    b printfor
endprintfor:
    li $v0, 10
    syscall # exit

quicksort:				#quicksort method

	addi $sp, $sp, -16		# Make room for 4
	sw $a0, 0($sp)			# a0
	sw $a1, 4($sp)			# low
	sw $a2, 8($sp)			# high
	sw $ra, 12($sp)			# return address

	move $t0, $a2			#saving high in t0

	slt $t1, $a1, $t0		# t1=1 if low < high, else 0
	beq $t1, $zero, endofQuicksort	# if low >= high, endif

	jal partition_Random	# call partition Random 
	move $s0, $v0			# pivot, s0= v0

	lw $a1, 4($sp)			#a1 = low
	addi $a2, $s0,0		    #a2 = pi 
	jal quicksort			#call quicksort

	addi $a1, $s0, 1		#a1 = pi + 1
	lw $a2, 8($sp)			#a2 = high
	jal quicksort			#call quicksort

endofQuicksort:
 	lw $a0, 0($sp)			#restore a0
 	lw $a1, 4($sp)			#restore a1
 	lw $a2, 8($sp)			#restore a2
 	lw $ra, 12($sp)			#restore return address
 	addi $sp, $sp, 16		#restore the stack
 	jr $ra				#return to caller

partition_Random:
    addi $sp, $sp, -16		# Make room for 4
	sw $a0, 0($sp)			# a0
	sw $a1, 4($sp)			# low
	sw $a2, 8($sp)			# high
	sw $ra, 12($sp)			# return address


	move $a0 , $a1 # low  a0= low
    move $a1 , $a2 # high a1= high
    move $t0 , $a0 # save a0 in t0 (low value) 
    sub $a1,$a1,$a0 # high - low 
    li $v0, 42
    syscall # a random number in range ( 0 , high - low )
    add $a0 , $a0 , $t0 #  a random number in range ( low  , high )
    move $a1 , $a0 # a1=  random pivot 

 	lw $a0, 0($sp)			#restore a0
    lw $a2, 4($sp)			#restore save low in a2 for swapping
							
    jal swap                # swap pivot and low
    lw $a1, 4($sp)			#restore a1
    lw $a2, 8($sp)			#restore a2
    
    jal partition

 	lw $a0, 0($sp)			#restore a0
 	lw $a1, 4($sp)			#restore a1
 	lw $a2, 8($sp)			#restore a2
 	lw $ra, 12($sp)			#restore return address
 	addi $sp, $sp, 16		#restore the stack    
    jr $ra
swap:					#swap method

	addi $sp, $sp, -12	# Make stack room for three
	sw $a0, 0($sp)		# Store a0
	sw $a1, 4($sp)		# Store a1
	sw $a2, 8($sp)		# store a2

	sll $t1, $a1, 2 	#t1 = 4a
	add $t1, $a0, $t1	#t1 = arr + 4a
	lw $s3, 0($t1)		#s3  t = array[a]

	sll $t2, $a2, 2		#t2 = 4b
	add $t2, $a0, $t2	#t2 = arr + 4b
	lw $s4, 0($t2)		#s4 = arr[b]

	sw $s4, 0($t1)		#arr[a] = arr[b]
	sw $s3, 0($t2)		#arr[b] = t 


	addi $sp, $sp, 12	#Restoring the stack size
	jr $ra			#jump back to the caller
	


partition: 			#partition method
    addi $sp, $sp, -16		# Make room for 4
	sw $a0, 0($sp)			# a0
	sw $a1, 4($sp)			# low
	sw $a2, 8($sp)			# high
	sw $ra, 12($sp)			# return address
    # finding pivot as low
    sll $s0,$a1,2
    add $s0,$s0,$a0
    lw $s1,0($s0) # s1 = pivot
    # finding i as low - 1
    addi $t9,$a1,-1
    # finding j as high +1
    addi $t8,$a2,1

    # while (True) loop 
    whileTloop:
    # do while 
    do1:
    addi $t9,$t9,1 # i++
    sll $t6 , $t9 , 2 
    add $t6,$t6,$a0 # t6 = arr + 4i
    lw $t6 , 0($t6)  # load arra[i]
    while1:
    slt $t5  , $t6 , $s1  # t5 =1 if arra[i] < pivot else 0
    beq $t5 , $zero , end1 # if arra[i] < pivot then endif
    j do1
    end1:

    do2:
    addi $t8,$t8,-1 # j--
    sll $t5 , $t8 , 2 
    add $t5,$t5,$a0 # t6 = arr + 4i
    lw $t5 , 0($t5)  # load array[j]
    while2:
    slt $t4 , $s1 , $t5  # t5 =1 if arra[j] > pivot else 0
    beq $t4 , $zero , end2 # if arra[i] <= pivot then endif
    j do2
    end2:
     slt $t4 , $t9 , $t8  # t4 =1 if i < j else 0
     bne $t4 , $zero , swapthenwhile # if i < j then 
     move $v0, $t8
     lw $a0, 0($sp)			#restore a0
     lw $a1, 4($sp)			#restore a1
     lw $a2, 8($sp)			#restore a2
     lw $ra, 12($sp)			#restore return address
     addi $sp, $sp, 16	#Restoring the stack size
     jr $ra
    swapthenwhile:
    move $a1 , $t9
    move $a2 , $t8
    jal swap

    b whileTloop
