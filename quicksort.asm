    .data       # here is data segment
    # TODO: your datas may be held here
    line_sep:    .asciiz "\n" 
    .text       # here is text segment
    .globl main
main:

    li $v0, 5
    syscall               
	# array length
    move $s7, $v0  

	sll $s6, $s7, 2   
       
    move $a0,$s6			 
	li $v0, 9                
    syscall
	
	move $s5, $v0 # pointer to the array

	move $t0, $s5           	 # pointer of the array
	
	add $t1, $s5, $s6


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
	addi $a2, $s0, -1		#a2 = pi -1
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
							# random r = low to high

	move $s0, $a1			#s0 = low 
	move $s1 , $ra 			# s1 = return address as random number

  	move $a0, $a1				# a0 = low 
  	addi $a1, $a2, 0 			# a1 = high 
	sub $a1, $a1, $a0			# a1 = high  - low

	div $s1, $a1				# t0 = random number / (high -low)
	mfhi $a2					# a2 = random number % (high -low)
    add $a1, $a0 , $a2          # a1 = r + low

 	lw $a0, 0($sp)			#restore a0
    lw $a2, 8($sp)			#restore a2
							# swap 
    jal swap
    lw $a1, 4($sp)			#restore a1
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

	addi $sp, $sp, -16	#Make room for 4
	sw $a0, 0($sp)		#store a0
	sw $a1, 4($sp)		#store a1
	sw $a2, 8($sp)		#store a2
	sw $ra, 12($sp)		#store return address
	
	move $s1, $a1		#s1 = low
	move $s2, $a2		#s2 = high

	sll $t1, $s2, 2		# t1 = 4*high
	add $t1, $a0, $t1	# t1 = arr + 4*high
	
	lw $t9, 0($t1)		# t9 = arr[high] //pivot

	addi $t3, $s1 , -1 	#t3, i=low -1
	move $t4, $s1		#t4, j=low
	addi $t5, $s2, -1	#t5 = high - 1

	forInPartition: 
		slt $t6, $t5, $t4	#t6=1 if j>high-1, t6=0 if j<=high-1
		bne $t6, $zero, endfor	#if t6=1 then branch to endfor

		sll $t1, $t4, 2		#t1 = j*4
		add $t1, $t1, $a0	#t1 = arr + 4j
		lw $t7, 0($t1)		#t7 = arr[j]

		slt $t8, $t9, $t7	#t8 = 1 if pivot < arr[j], 0 if arr[j]<=pivot
		bne $t8, $zero, If_InFor	#if t8=1 then branch to If_InFor
		addi $t3, $t3, 1	#i=i+1
		move $a1, $t3		#a1 = i++
		move $a2, $t4		#a2 = j
		jal swap		#swap(arr, i, j)
		addi $t4, $t4, 1	#j++
		
		j forInPartition

	    If_InFor:
		addi $t4, $t4, 1	#j++
		j forInPartition		#jump back to forInPartition

	endfor:
		addi $a1, $t3, 1		#a1 = i + 1
		move $a2, $s2			#a2 = high
		add $v0, $zero, $a1		#v0 = i+1 return (i + 1);
		jal swap			#swap(arr, i + 1, high);
		lw $ra, 12($sp)			#return address
		addi $sp, $sp, 16		#restore the stack
		jr $ra				#junp back to the caller