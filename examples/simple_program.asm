# Simple program to test the MIPS pipeline simulator
# This program calculates the sum of numbers from 1 to 10

# # Initialize registers
# addi $t0, $zero, 0  # Sum = 0
# addi $t1, $zero, 1  # Counter = 1
# addi $t2, $zero, 10 # Limit = 10

# # Loop to calculate sum
# add $t0, $t0, $t1   # Sum += Counter
# addi $t1, $t1, 1    # Counter++
# sub $t3, $t2, $t1   # $t3 = Limit - Counter
# or $t3, $t3, $zero  # This instruction will test forwarding
# addi $t4, $zero, 4096 # Memory address
# sw $t0, 0($t4)      # Store sum in memory
# lw $t5, 0($t4)      # Load sum from memory

# addi $t1, $zero, 4096   # Load address
# lw   $t0, 0($t1)        # Load word into $t0 from memory
# add  $t2, $t0, $t0      # Use loaded value immediately (should stall)
# addi $t3, $t2, 5        # Another dependent instruction

# Final result should be in $t0 and $t5 (both should be 55)

addi $t0, $zero, 4096     # i1 $t0 = 0x1000 (address)
addi $t1, $zero, 5        # i2 $t1 = 5
addi $t2, $zero, 3        # i3 $t2 = 3

add  $t3, $t1, $t2        # i4 (uses results from i2, i3) $t3 = 8
sub  $t4, $t1, $t2        # i5 (same) $t4 = 2
and  $t5, $t1, $t2        # i6 (same) $t5 = 1
or   $t6, $t1, $t2        # i7 (same) $t6 = 7
xor  $t7, $t1, $t2        # i8 (same) $t7 = 6
nor  $s0, $t1, $t2        # i9 (same) $s0 = -6
sw   $t3, 0($t0)          # i9 (uses $t0 from i1) $t3 = 8
sll $t3, $t1, 2        # i10 (same) $s1 = 20

lw   $s1, 0($t0)          # i10 (uses $t0 from i1)
sw   $s1, 4($t0)          # i11 (uses $s1 from i10 and $t0)
