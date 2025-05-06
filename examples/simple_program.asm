# Simple program to test the MIPS pipeline simulator
# This program calculates the sum of numbers from 1 to 10

# Initialize registers
addi $t0, $zero, 0  # Sum = 0
addi $t1, $zero, 1  # Counter = 1
addi $t2, $zero, 10 # Limit = 10

# Loop to calculate sum
add $t0, $t0, $t1   # Sum += Counter
addi $t1, $t1, 1    # Counter++
sub $t3, $t2, $t1   # $t3 = Limit - Counter
or $t3, $t3, $zero  # This instruction will test forwarding
addi $t4, $zero, 100 # Memory address
sw $t0, 0($t4)      # Store sum in memory
lw $t5, 0($t4)      # Load sum from memory

# Final result should be in $t0 and $t5 (both should be 55)