# Name: Siddharth Singh Ahluwalia
# Roll No.: CS19BTECH11056

.text
.globl main

#pseudocode:
#int main()
#{
#	int a, r, n;
#	printf("Enter n, a and r\n");
#	scanf("%d %d %d", &n, &a, &r);
#
#	int arr[n];
#	arr[0] = a;
#	for(int i=1; i<n; i++)
#	{
#		arr[i] = arr[i-1]*r;
#	}
#	assending(arr, n);
#	decending(arr, n);
#	randomising(arr, n);
#
#	return 0;
#}
main:
	
	#register conventions
	# $s1 - a
	# $s2 - r
	# $s3 - n
	# $s0 - base address of array arr[n]

	# printf("enter n, a and r\n")
	li $v0, 4
	la $a0, prompt
	syscall

	#scanf("%d", &n)
	li $v0, 5
	syscall
	move $s3, $v0
	#scanf("%d", &a)
	li $v0, 5
	syscall
	move $s1, $v0
	#scanf("%d", &r)
	li $v0, 5
	syscall
	move $s2, $v0

	# int arr[n]
	move $a0, $s3
	jal AllocateArray
	move $s0, $v0
	
	#a[0] = a
	sw $s1, 0($s0)
	
	#for loop 
	# $t1 - i
	li $t1, 1
	loop_1:
			slt $t2, $t1, $s3
			beq $t2, $zero, out_1

			move $a0, $s0
			addi $a1, $t1, -1
			jal LoadArrayAddress
			lw $t2, 0($v0)

			mul $t2, $t2, $s2

			move $a0, $s0
			move $a1, $t1
			jal LoadArrayAddress
			sw $t2, 0($v0)

			addi $t1, $t1, 1
			j loop_1
			out_1:
	
	# procedure calls
	move $a0, $s0
	move $a1, $s3

	jal assending
	jal decending
	jal randomising
	
	# exit program
	li $v0, 10
	syscall

.data

prompt: .asciiz "Enter n, a and r\n"
space: .asciiz "  "
newline: .asciiz "\n"

.text

# this procedure allocates array of given size, each element have 4 bytes size
# register conventions
# $a0 - number of items to be store array
# $v0 - base address of new allocated array
AllocateArray:
			addi $sp, $sp, -8
			sw $ra, 0($sp)
			sw $a0, 4($sp)
			
			sll $a0, $a0, 2
			li $v0, 9
			syscall

			lw $ra, 0($sp)
			lw $a0, 4($sp)
			addi $sp, $sp, 8

			jr $ra

# this procedure gives address of element in array for a given index value
# register conventions
# $a0 - base address of array
# $a1 - index of element in array
# $v0 - address of element in array of index $a1
LoadArrayAddress:
			addi $sp, $sp, -12
			sw $ra, 0($sp)
			sw $a0, 4($sp)
			sw $a1, 8($sp)

			mul $a1, $a1, 4
			add $a0, $a0, $a1
			move $v0, $a0

			lw $ra, 0($sp)
			lw $a0, 4($sp)
			lw $a1, 8($sp)
			addi $sp, $sp, 12

			jr $ra

# this procedure prints elements of an array
PrintArray:
		addi $sp, $sp, -12
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		sw $a1, 8($sp)

		li $t1, 0
		move $t3, $a0
		loop:
			slt $t2, $t1, $a1
			beq $t2, $zero, out

			lw $a0, 0($t3)

			li $v0, 1
			syscall

			la $a0, space
			li $v0, 4
			syscall

			addi $t1, $t1, 1
			addi $t3, $t3, 4
			j loop
		out:

		lw $ra, 0($sp)
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		addi $sp, $sp, 12

		jr $ra


# Pseudo Code for insertion sort
#
# int insertion_sort(int a[], int n)
# {
# 	int compare = 0;# 
# 	int key;
# 
# 	for(int i=1; i<n; i++)
# 	{
# 		key = a[i];
# 		int j = i - 1;
# 		while((j>=0) && (compare++) && (a[j]>key))
# 		{
# 			a[j+1] = a[j];
# 			j--;
# 		}
# 		a[j+1] = key;
# 	}
# 	return compare;
# }

# register convention
# $a0 - base address of array arr[n]
# $a1 - number of items in array arr
# $t1 - compare
# $v0 - return compare
# $t2 - key
# $t3 - i
# $t4 - j

insertion_sort:
			addi $sp, $sp, -12
			sw $ra, 0($sp)
			sw $a0, 4($sp)
			sw $a1, 8($sp)

			#compare = 0
			li $t1, 0
			
			# i = 1
			li $t3, 1
			loop_2:
					slt $t5, $t3, $a1
					beq $t5, $zero, out_2

					# key = arr[i]
					move $a1, $t3
					jal LoadArrayAddress
					lw $t2, 0($v0)
					

					# j = i - 1
					addi $t4, $t3, -1

					#while((compare++) && (j>=0) && (a[j]>key))
					inner_loop:
								# j >= 0
								sge $t5, $t4, $zero
								beq $t5, $zero, out_inner

								# a[j]
								move $a1, $t4
								jal LoadArrayAddress
								lw $t6, 0($v0)
								lw $a1, 8($sp)

								# compare++
								addi $t1, $t1, 1

								# a[j] > key
								sgt $t5, $t6, $t2
								beq $t5, $zero, out_inner

								# a[j+1] = a[j]
								lw $t6, 4($v0)

								# j--
								addi $t4, $t4, -1

								j inner_loop
								out_inner:
					# a[j+1] = key
					lw $t2, 4($v0)

					# i++
					addi $t3, $t3, 1

					j loop_2
					out_2:
			move $v0, $t1

			lw $ra, 0($sp)
			lw $a0, 4($sp)
			lw $a1, 8($sp)
			addi $sp, $sp, 12

			jr $ra


# Pseudo Code
# void assending(int a[], int n)
# {
# 	print_array(a, n);
# 
# 	printf("%d\n", insertion_sort(a, n));
# }

# register conventions
# $a0 - base address of array a[]
# $a1 - number of elements in array a[]
assending:
		addi $sp, $sp, -12
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		sw $a1, 8($sp)

		jal PrintArray

		#printf("\n");
		la $a0, newline
		li $v0, 4
		syscall
		
		# printf("%d", insertion_sort(a, n));
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		jal insertion_sort
		move $a0, $v0
		li $v0, 1
		syscall
		
		#printf("\n");
		la $a0, newline
		li $v0, 4
		syscall

		lw $ra, 0($sp)
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		addi $sp, $sp, 12

		jr $ra


# Pseudo Code
# void decending(int a[], int n)
# {
# 	int decrease[n];
# 	for(int i=0; i<n; i++)
# 	{
# 		decrease[n-1-i] = a[i];
# 	}
# 	print_array(decrease, n);
# 
# 	printf("%d\n", insertion_sort(decrease, n));
# }
#
# register convention
# $a0 - base address of array a[]
# $a1 - number of items in array a[]
# $t0 - base address of array decrease[]
# $t1 - i
# $v0 - number of compares in insertion sort algorithm
# $s1 - number of items in array a[]
# $s0 - base address of array a[]

decending:
		addi $sp, $sp, -20
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $s0, 12($sp)
		sw $s1, 16($sp)

		move $s0, $a0
		move $s1, $a1

		# int decrease[n]
		move $a0, $a1
		jal AllocateArray
		move $t0, $v0

		li $t1, 0
		loop_3:
				slt $t2, $t1, $s1
				beq $t2, $zero, out_3

				# a[i] in $t2
				move $a0, $s0
				move $a1, $t1
				jal LoadArrayAddress
				lw $t2, 0($v0)

				# n-1-i in $t3
				sub $t3, $s1, $t1
				addi $t3, $t3, -1

				#decrease[n-1-i] = a[i]
				move $a0, $t0
				move $a1, $t3
				jal LoadArrayAddress
				sw $t2, 0($v0)

				#i++
				addi $t1, $t1, 1

				j loop_3
				out_3:
		# 	print_array(decrease, n)
		move $a0, $t0
		move $a1, $s1
		jal PrintArray

		# printf("\n")
		la $a0, newline
		li $v0, 4
		syscall

		# 	printf("%d", insertion_sort(decrease, n))
		move $a0, $t0
		move $a1, $s1
		jal insertion_sort
		move $a0, $v0
		li $v0, 1
		syscall

		# printf("\n")
		la $a0, newline
		li $v0, 4
		syscall

		lw $ra, 0($sp)
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $s0, 12($sp)
		lw $s1, 16($sp)
		addi $sp, $sp, 20

		jr $ra

# Pseudo Code
# void randomising(int ar[], int n)
# {
# 	srand(time(NULL));
# 
# 	int r[n];
# 	int a, b;
# 
# 	for(int i=0; i<n; i++)
# 	{
# 		r[i] = ar[i];
# 	}
# 	/*Fisher-Yates shuffle algorithm*/
# 	for(int i=n-1; i>0; i--)
# 	{
# 		a = rand() % (i+1);
# 		
# 		swap(&r[a], &r[i]);
# 	}
# 	print_array(r, n);
# 	printf("%d\n", insertion_sort(r, n));
# }
#
# register conventions
# $a0 - base address of array a[]
# $a1 - number of items in array a[]
# $s0 - base address of array a[]
# $s1 - number of elements of array a[]
# $t0 - base address of array r[]
# $t1 - a
# $t2 - i
randomising:
			addi $sp, $sp, -20
			sw $ra, 0($sp)
			sw $a0, 4($sp)
			sw $a1, 8($sp)
			sw $s0, 12($sp)
			sw $s1, 16($sp)

			# seed random number generator
			# get time in miliseconds(64-bit value) and its lower 32-bit stores in $a0
			li $v0, 30
			syscall

			# set random number generator id 1
			move $a1, $a0
			li $a0, 1
			li $v0, 40
			syscall
			# seeding done

			lw $s0, 4($sp)
			lw $s1, 8($sp)

			# int r[n]
			move $a0, $s1
			jal AllocateArray
			move $t0, $v0

			#for loop
			li $t2, 0
			loop_4:
					slt $t3, $t2, $s1
					beq $t3, $zero, out_4

					#a[i] in $t3
					move $a0, $s0
					move $a1, $t2
					jal LoadArrayAddress
					lw $t3, 0($v0)

					# r[i] = a[i]
					move $a0, $t0
					move $a1, $t2
					jal LoadArrayAddress
					sw $t3, 0($v0)

					addi $t2, $t2, 1
					j loop_4
					out_4:

			# Fisher-Yates shuffle algorithm
			# i = n-1
			addi $t2, $s1, -1
			loop_5:
					sgt $t3, $t2, $zero
					beq $t3, $zero, out_5

					# random number in $t1 from random number generator of id 1
					addi $a1, $t2, 1
					li $a0, 1
					li $v0, 42
					syscall
					move $t1, $a0

					# swap r[a] and r[i]
					# r[a] in $t3
					move $a0, $t0
					move $a1, $t1
					jal LoadArrayAddress
					lw $t3, 0($v0)
					move $t5, $v0
					# r[i] in $t4
					move $a0, $t0
					move $a1, $t2
					jal LoadArrayAddress
					lw $t4, 0($v0)
					# r[i] = r[a]
					sw $t3, 0($v0)
					# r[a] = r[i]
					sw $t4, 0($t5)

					# i--
					addi $t2, $t2, -1

					j loop_5
					out_5:

			# print_array(r, n)
			move $a0, $t0
			move $a1, $s1
			jal PrintArray

			# printf("\n")
			la $a0, newline
			li $v0, 4
			syscall

			# printf("%d", insertion_sort(r, n))
			move $a0, $t0
			move $a1, $s1
			jal insertion_sort
			move $a0, $v0
			li $v0, 1
			syscall

			# printf("\n")
			la $a0, newline
			li $v0, 4
			syscall

			lw $ra, 0($sp)
			lw $a0, 4($sp)
			lw $a1, 8($sp)
			lw $s0, 12($sp)
			lw $s1, 16($sp)
			addi $sp, $sp, 20

			jr $ra
