.data
# Data for generating random number Xn+1 = (a*Xn + c) % m
seed: .word 23         # Initial seed value
a:    .word 1664525    # Multiplier
c:    .word 1013904223 # Icrement
m:    .word 100	       # Module
end_timer: .word 0x030  # Mark for end of countdown


# Data for MMIO Simulator
.eqv REC_CTRL_REG 0xffff0000  # Receiver Control Register
.eqv REC_DATA_REG 0xffff0004  # Receiver Data Register
.eqv TRAN_CTRL_REG 0xffff0008 # Transmitter Control Register
.eqv TRAN_DATA_REG 0xffff000c # Transmitter Data Register
.eqv CLEAR 0x0C	      	      # Clear the display
.eqv NEWLINE 0x0A	      # Newline for display the timer
.eqv SPACE 0x20		      

# Data for guessing
message: .asciz "Type your number: "
win: 	 .asciz "Congrats, you win!"
lose: 	 .asciz "Failed, you lose!"
arr: 	 .space 12 # Store the random number 
end_arr: .space 

.text
main:
li s0, 0
li s1, 3	# Generate 3 random numbers
la s2, arr

loop:
la t6, seed
lw t0, 0(t6)	# Load seed 
lw t1, a	# Load Multiplier
lw t2, c	# Load Increment
lw t3, m	# Load the module

# Generate random number
generate_random_number:
mul t4, t0, t1  # a*Xn
add t4, t4, t2  # a*Xn + c
rem t4, t4, t3  # Take module
sw t4, 0(t6)    # Store the new seed
sw t4, 0(s2)	# Add the random number to array to check guessing
addi s2, s2, 4
addi s0, s0, 1
end_of_generating:

# Show on the display of the MMIO
display_start:

### Write to the transmitter data register
li t0, TRAN_DATA_REG
li t1, 10
mv t2, t4
div t3, t2, t1  # First char
rem t4, t2, t1	# Next char
addi t3, t3, 0x030
addi t4, t4, 0x030
sw t3, 0(t0)	
jal wait_display_ready
sw t4, 0(t0)
jal wait_display_ready
li t1, SPACE
sw t1, 0(t0)
jal wait_display_ready
blt s0, s1, loop

# Generate countdown timer (10 second) from 10 - 0
timer_start:
lw t3, end_timer
li t0, TRAN_DATA_REG		  # Load the display data register
li t1, NEWLINE		
sw t1, 0(t0)			  # Newline for the timer
jal wait_display_ready

print_10:
li t2, 0x031
sw t2, 0(t0)
jal wait_display_ready	 	  # Wait for display ready bit
li t2, 0x030
sw t2, 0(t0)
jal wait_display_ready	 	  # Wait for display ready bit
jal wait_1_sec
sw t1, 0(t0)
jal wait_display_ready
li t2, 0x039

countdown_to_0:
sw t2, 0(t0)
jal wait_display_ready
jal wait_1_sec
addi t2, t2, -1
blt t2, t3, clear_display
sw t1, 0(t0)
jal wait_display_ready
j countdown_to_0
timer_end:

### Clear the display
clear_display:
li t0, TRAN_DATA_REG
li t1, CLEAR
sw t1, 0(t0)
jal wait_display_ready

# Start guessing
start_guessing:
li a0, 1 		# Boolean to check 
li a1, SPACE
li a2, 0		# Count
li a3, 3		# Max input
la a4, end_arr
typing:
addi a2, a2, 1
bgt a2, a3, result
### Wait for a key press 
li t0, REC_CTRL_REG_ADDR
lw t1, 0(t0)           	# Load the value from Receiver Control Register
andi t1, t1, 1         	# Check the ready bit
beqz t1, loop          	# If ready bit is 0, stay in the loop


#--------------------------------------------------------------------#
# Procedure for wait_1_sec
wait_1_sec:
li a0, 6
wait:
beqz a0, end_1_sec
addi a0, a0, -1
j wait
end_1_sec:
jr ra

# Procedure for wait_display_ready
wait_display_ready:
li a0, TRAN_CTRL_REG
lw a1, 0(a0)	# Load the register
andi a1, a1, 1  # Check the ready bit
beqz a1, wait_display_ready # If ready bit = 0, wait
display_end:
jr ra.data
# Data for generating random number Xn+1 = (a*Xn + c) % m
seed: .word 23         # Initial seed value
a:    .word 1664525    # Multiplier
c:    .word 1013904223 # Icrement
m:    .word 100	       # Module
end_timer: .word 0x030  # Mark for end of countdown


# Data for MMIO Simulator
.eqv REC_CTRL_REG 0xffff0000  # Receiver Control Register
.eqv REC_DATA_REG 0xffff0004  # Receiver Data Register
.eqv TRAN_CTRL_REG 0xffff0008 # Transmitter Control Register
.eqv TRAN_DATA_REG 0xffff000c # Transmitter Data Register
.eqv CLEAR 0x0C	      	      # Clear the display
.eqv NEWLINE 0x0A	      # Newline for display the timer
.eqv SPACE 0x20		      

# Data for guessing
message: .asciz "Type your number: "
win: 	 .asciz "Congrats, you win!"
lose: 	 .asciz "Failed, you lose!"
arr: 	 .space 12 # Store the random number 
end_arr: .space 

.text
main:
li s0, 0
li s1, 3	# Generate 3 random numbers
la s2, arr

loop:
la t6, seed
lw t0, 0(t6)	# Load seed 
lw t1, a	# Load Multiplier
lw t2, c	# Load Increment
lw t3, m	# Load the module

# Generate random number
generate_random_number:
mul t4, t0, t1  # a*Xn
add t4, t4, t2  # a*Xn + c
rem t4, t4, t3  # Take module
sw t4, 0(t6)    # Store the new seed
sw t4, 0(s2)	# Add the random number to array to check guessing
addi s2, s2, 4
addi s0, s0, 1
end_of_generating:

# Show on the display of the MMIO
display_start:

### Write to the transmitter data register
li t0, TRAN_DATA_REG
li t1, 10
mv t2, t4
div t3, t2, t1  # First char
rem t4, t2, t1	# Next char
addi t3, t3, 0x030
addi t4, t4, 0x030
sw t3, 0(t0)	
jal wait_display_ready
sw t4, 0(t0)
jal wait_display_ready
li t1, SPACE
sw t1, 0(t0)
jal wait_display_ready
blt s0, s1, loop

# Generate countdown timer (10 second) from 10 - 0
timer_start:
lw t3, end_timer
li t0, TRAN_DATA_REG		  # Load the display data register
li t1, NEWLINE		
sw t1, 0(t0)			  # Newline for the timer
jal wait_display_ready

print_10:
li t2, 0x031
sw t2, 0(t0)
jal wait_display_ready	 	  # Wait for display ready bit
li t2, 0x030
sw t2, 0(t0)
jal wait_display_ready	 	  # Wait for display ready bit
jal wait_1_sec
sw t1, 0(t0)
jal wait_display_ready
li t2, 0x039

countdown_to_0:
sw t2, 0(t0)
jal wait_display_ready
jal wait_1_sec
addi t2, t2, -1
blt t2, t3, clear_display
sw t1, 0(t0)
jal wait_display_ready
j countdown_to_0
timer_end:

### Clear the display
clear_display:
li t0, TRAN_DATA_REG
li t1, CLEAR
sw t1, 0(t0)
jal wait_display_ready

# Start guessing
start_guessing:
li a0, 1 		# Boolean to check 
li a1, SPACE
li a2, 0		# Count
li a3, 3		# Max input
la a4, end_arr
typing:
addi a2, a2, 1
bgt a2, a3, result
### Wait for a key press 
li t0, REC_CTRL_REG_ADDR
lw t1, 0(t0)           	# Load the value from Receiver Control Register
andi t1, t1, 1         	# Check the ready bit
beqz t1, loop          	# If ready bit is 0, stay in the loop


#--------------------------------------------------------------------#
# Procedure for wait_1_sec
wait_1_sec:
li a0, 6
wait:
beqz a0, end_1_sec
addi a0, a0, -1
j wait
end_1_sec:
jr ra

# Procedure for wait_display_ready
wait_display_ready:
li a0, TRAN_CTRL_REG
lw a1, 0(a0)	# Load the register
andi a1, a1, 1  # Check the ready bit
beqz a1, wait_display_ready # If ready bit = 0, wait
display_end:
jr ra