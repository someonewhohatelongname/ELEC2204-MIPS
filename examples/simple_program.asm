
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

# addi $t0, $zero, 4096     # i1 $t0 = 0x1000 (address)
# addi $t1, $zero, 5        # i2 $t1 = 5
# addi $t2, $zero, 3        # i3 $t2 = 3

# add  $t3, $t1, $t2        # i4 (uses results from i2, i3) $t3 = 8
# sub  $t4, $t1, $t2        # i5 (same) $t4 = 2
# and  $t5, $t1, $t2        # i6 (same) $t5 = 1
# or   $t6, $t1, $t2        # i7 (same) $t6 = 7
# xor  $t7, $t1, $t2        # i8 (same) $t7 = 6
# nor  $s0, $t1, $t2        # i9 (same) $s0 = -6
# sw   $t3, 0($t0)          # i9 (uses $t0 from i1) $t3 = 8
# sll $t3, $t1, 2        # i10 (same) $s1 = 20

# lw   $s1, 0($t0)          # i10 (uses $t0 from i1)
# sw   $s1, 4($t0)          # i11 (uses $s1 from i10 and $t0)

#Showcase program

addi $s0, $zero, 4096     # Set $s0 = 0x1000 (starting memory address)

# Square of 0 = 0
addi $a0, $zero, 0       # Set $a0 = 0
sw $a0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 1 = 1
addi $a0, $zero, 1       # Set $a0 = 1
sw $a0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 2 = 4
addi $a0, $zero, 2       # Set $a0 = 2
sll $t0, $a0, 1          # $t0 = $a0 << 1 = 2 * 2 = 4
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 3 = 9
addi $a0, $zero, 3       # Set $a0 = 3
sll $t0, $a0, 1          # $t0 = $a0 << 1 = 3 * 2 = 6
add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 6 + 3 = 9
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 4 = 16
addi $a0, $zero, 4       # Set $a0 = 4
sll $t0, $a0, 2          # $t0 = $a0 << 2 = 4 * 4 = 16
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 5 = 25
addi $a0, $zero, 5       # Set $a0 = 5
sll $t0, $a0, 2          # $t0 = $a0 << 2 = 5 * 4 = 20
add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 20 + 5 = 25
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 6 = 36
addi $a0, $zero, 6       # Set $a0 = 6
sll $t0, $a0, 3          # $t0 = $a0 << 2 = 6 * 4 = 24
sll $t1, $a0, 1          # $t1 = $a0 << 1 = 6 * 2 = 12
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 24 + 12 = 36
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 7 = 49
addi $a0, $zero, 7       # Set $a0 = 7
sll $t0, $a0, 3          # $t0 = $a0 << 3 = 7 * 8 = 56
sub $t0, $t0, $a0        # $t0 = $t0 - $a0 = 56 - 7 = 49
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 8 = 64
addi $a0, $zero, 8       # Set $a0 = 8
sll $t0, $a0, 3          # $t0 = $a0 << 3 = 8 * 8 = 64
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 9 = 81
addi $a0, $zero, 9       # Set $a0 = 9
sll $t0, $a0, 3          # $t0 = $a0 << 3 = 9 * 8 = 72
add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 72 + 9 = 81
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 10 = 100
addi $a0, $zero, 10      # Set $a0 = 10
sll $t0, $a0, 3          # $t0 = $a0 << 3 = 10 * 8 = 80
sll $t1, $a0, 1          # $t1 = $a0 << 1 = 10 * 2 = 20
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 80 + 20 = 100
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 11 = 121
addi $a0, $zero, 11      # Set $a0 = 11
sll $t0, $a0, 3          # $t0 = $a0 << 3 = 11 * 8 = 88
sll $t1, $a0, 1          # $t1 = $a0 << 1 = 11 * 2 = 22
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 88 + 22 = 110
add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 110 + 11 = 121
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 12 = 144
addi $a0, $zero, 12      # Set $a0 = 12
sll $t0, $a0, 4          # $t0 = $a0 << 4 = 12 * 16 = 192
sll $t1, $a0, 2          # $t1 = $a0 << 2 = 12 * 4 = 48
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 192 - 48 = 144
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 13 = 169
addi $a0, $zero, 13      # Set $a0 = 13
sll $t0, $a0, 4          # $t0 = $a0 << 4 = 13 * 16 = 208
sll $t1, $a0, 2          # $t1 = $a0 << 2 = 13 * 4 = 52
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 208 - 52 = 156
add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 156 + 13 = 169
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 14 = 196
addi $a0, $zero, 14      # Set $a0 = 14
sll $t0, $a0, 4          # $t0 = $a0 << 4 = 14 * 16 = 224
sll $t1, $a0, 1          # $t1 = $a0 << 1 = 14 * 2 = 28
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 224 - 28 = 196
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 15 = 225
addi $a0, $zero, 15      # Set $a0 = 15
sll $t0, $a0, 4          # $t0 = $a0 << 4 = 15 * 16 = 240
sub $t0, $t0, $a0        # $t0 = $t0 - $a0 = 240 - 15 = 225
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 16 = 256
addi $a0, $zero, 16      # Set $a0 = 16
sll $t0, $a0, 4          # $t0 = $a0 << 4 = 16 * 16 = 256
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Continue with patterns for remaining numbers...
# For each number, we'll use bit shifting and add/subtract operations
# to efficiently calculate squares

# Square of 17 = 289
addi $a0, $zero, 17      # Set $a0 = 17
sll $t0, $a0, 4          # $t0 = $a0 << 4 = 17 * 16 = 272
add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 272 + 17 = 289
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 18 = 324
addi $a0, $zero, 18      # Set $a0 = 18
sll $t0, $a0, 4          # $t0 = $a0 << 4 = 18 * 16 = 288
sll $t1, $a0, 1          # $t1 = $a0 << 1 = 18 * 2 = 36
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 288 + 36 = 324
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 19 = 361
addi $a0, $zero, 19      # Set $a0 = 19
sll $t0, $a0, 4          # $t0 = $a0 << 4 = 19 * 16 = 304
sll $t1, $a0, 2          # $t1 = $a0 << 2 = 19 * 4 = 76
sub $t2, $t0, $t1        # $t2 = $t0 - $t1 = 304 - 76 = 228
sll $t1, $a0, 3          # $t1 = $a0 << 3 = 19 * 8 = 152
sub $t0, $t1, $a0        # $t0 = $t1 - $a0 = 152 - 19 = 133
add $t0, $t0, $t2        # $t0 = $t0 + $t2 = 133 + 228 = 361
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 20 = 400
addi $a0, $zero, 20      # Set $a0 = 20
sll $t0, $a0, 4          # $t0 = $a0 << 4 = 20 * 16 = 320
sll $t1, $a0, 2          # $t1 = $a0 << 2 = 20 * 4 = 80
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 320 + 80 = 400
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# I'll continue with more efficient patterns for the remaining squares
# For larger numbers we'll use combinations of shifts and add/subtract operations

# Square of 21 = 441
addi $a0, $zero, 21      # Set $a0 = 21
sll $t0, $a0, 5          # $t0 = $a0 << 5 = 21 * 32 = 672
sll $t1, $a0, 3          # $t1 = $a0 << 3 = 21 * 8 = 168
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 672 - 168 = 504
sll $t1, $a0, 2          # $t1 = $a0 << 2 = 21 * 4 = 84
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 504 - 84 = 420
add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 420 + 21 = 441
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# For brevity, I'll skip ahead to some larger numbers...

# Square of 22 = 484
addi $a0, $zero, 22      # Set $a0 = 22
sll $t0, $a0, 5          # $t0 = $a0 << 5 = 22 * 32 = 704
sll $t1, $a0, 4          # $t1 = $a0 << 4 = 22 * 16 = 352
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 704 - 352 = 352
sll $t1, $a0, 2          # $t1 = $a0 << 2 = 22 * 4 = 88
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 352 + 88 = 440
add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 440 + 22 = 462
add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 462 + 22 = 484
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 23 = 529
addi $a0, $zero, 23      # Set $a0 = 23
sll $t0, $a0, 5          # $t0 = $a0 << 5 = 23 * 32 = 736
sll $t1, $a0, 4          # $t1 = $a0 << 4 = 23 * 16 = 368
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 736 - 368 = 368
sll $t1, $a0, 3          # $t1 = $a0 << 3 = 23 * 8 = 184
sub $t2, $t1, $a0        # $t2 = $t1 - $a0 = 184 - 23 = 161
add $t0, $t0, $t2        # $t0 = $t0 + $t2 = 368 + 161 = 529
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 24 = 576
addi $a0, $zero, 24      # Set $a0 = 24
sll $t0, $a0, 5          # $t0 = $a0 << 5 = 24 * 32 = 768
sll $t1, $a0, 4          # $t1 = $a0 << 4 = 24 * 16 = 384
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 768 - 384 = 384
sll $t1, $a0, 3          # $t1 = $a0 << 3 = 24 * 8 = 192
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 384 + 192 = 576
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 25 = 625
addi $a0, $zero, 25      # Set $a0 = 25
sll $t0, $a0, 5          # $t0 = $a0 << 5 = 25 * 32 = 800
sll $t1, $a0, 4          # $t1 = $a0 << 4 = 25 * 16 = 400
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 800 - 400 = 400
sll $t1, $a0, 3          # $t1 = $a0 << 3 = 25 * 8 = 200
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 400 + 200 = 600
add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 600 + 25 = 625
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 26 = 676
addi $a0, $zero, 26      # Set $a0 = 26
sll $t0, $a0, 5          # $t0 = $a0 << 5 = 26 * 32 = 832
sll $t1, $a0, 4          # $t1 = $a0 << 4 = 26 * 16 = 416
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 832 - 416 = 416
sll $t1, $a0, 3          # $t1 = $a0 << 3 = 26 * 8 = 208
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 416 + 208 = 624
sll $t1, $a0, 1          # $t1 = $a0 << 1 = 26 * 2 = 52
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 624 + 52 = 676
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 27 = 729
addi $a0, $zero, 27      # Set $a0 = 27
sll $t0, $a0, 5          # $t0 = $a0 << 5 = 27 * 32 = 864
sll $t1, $a0, 4          # $t1 = $a0 << 4 = 27 * 16 = 432
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 864 - 432 = 432
sll $t1, $a0, 3          # $t1 = $a0 << 3 = 27 * 8 = 216
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 432 + 216 = 648
sll $t1, $a0, 2          # $t1 = $a0 << 2 = 27 * 4 = 108
sub $t2, $t1, $a0        # $t2 = $t1 - $a0 = 108 - 27 = 81
add $t0, $t0, $t2        # $t0 = $t0 + $t2 = 648 + 81 = 729
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 28 = 784
addi $a0, $zero, 28      # Set $a0 = 28
sll $t0, $a0, 5          # $t0 = $a0 << 5 = 28 * 32 = 896
sll $t1, $a0, 4          # $t1 = $a0 << 4 = 28 * 16 = 448
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 896 - 448 = 448
sll $t1, $a0, 3          # $t1 = $a0 << 3 = 28 * 8 = 224
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 448 + 224 = 672
sll $t1, $a0, 2          # $t1 = $a0 << 2 = 28 * 4 = 112
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 672 + 112 = 784
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 29 = 841
addi $a0, $zero, 29      # Set $a0 = 29
sll $t0, $a0, 5          # $t0 = $a0 << 5 = 29 * 32 = 928
sll $t1, $a0, 4          # $t1 = $a0 << 4 = 29 * 16 = 464
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 928 - 464 = 464
sll $t1, $a0, 3          # $t1 = $a0 << 3 = 29 * 8 = 232
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 464 + 232 = 696
sll $t1, $a0, 2          # $t1 = $a0 << 2 = 29 * 4 = 116
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 696 + 116 = 812
add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 812 + 29 = 841
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 30 = 900
addi $a0, $zero, 30      # Set $a0 = 30
sll $t0, $a0, 5          # $t0 = $a0 << 5 = 30 * 32 = 960
sll $t1, $a0, 4          # $t1 = $a0 << 4 = 30 * 16 = 480
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 960 - 480 = 480
sll $t1, $a0, 3          # $t1 = $a0 << 3 = 30 * 8 = 240
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 480 + 240 = 720
sll $t1, $a0, 2          # $t1 = $a0 << 2 = 30 * 4 = 120
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 720 + 120 = 840
sll $t1, $a0, 1          # $t1 = $a0 << 1 = 30 * 2 = 60
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 840 + 60 = 900
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 31 = 961
addi $a0, $zero, 31      # Set $a0 = 31
sll $t0, $a0, 5          # $t0 = $a0 << 5 = 31 * 32 = 992
sll $t1, $a0, 3          # $t1 = $a0 << 3 = 31 * 8 = 248
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 992 - 248 = 744
sll $t1, $a0, 2          # $t1 = $a0 << 2 = 31 * 4 = 124
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 744 + 124 = 868
sll $t1, $a0, 1          # $t1 = $a0 << 1 = 31 * 2 = 62
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 868 + 62 = 930
add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 930 + 31 = 961
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 32 = 1024
addi $a0, $zero, 32      # Set $a0 = 32
sll $t0, $a0, 5          # $t0 = $a0 << 5 = 32 * 32 = 1024
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 33 = 1089
addi $a0, $zero, 33      # Set $a0 = 33
sll $t0, $a0, 5          # $t0 = $a0 << 5 = 33 * 32 = 1056
add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 1056 + 33 = 1089
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 34 = 1156
addi $a0, $zero, 34      # Set $a0 = 34
sll $t0, $a0, 5          # $t0 = $a0 << 5 = 34 * 32 = 1088
sll $t1, $a0, 1          # $t1 = $a0 << 1 = 34 * 2 = 68
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 1088 + 68 = 1156
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 35 = 1225
addi $a0, $zero, 35      # Set $a0 = 35
sll $t0, $a0, 5          # $t0 = $a0 << 5 = 35 * 32 = 1120
sll $t1, $a0, 2          # $t1 = $a0 << 2 = 35 * 4 = 140
sub $t2, $t1, $a0        # $t2 = $t1 - $a0 = 140 - 35 = 105
add $t0, $t0, $t2        # $t0 = $t0 + $t2 = 1120 + 105 = 1225
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 36 = 1296
addi $a0, $zero, 36      # Set $a0 = 36
sll $t0, $a0, 5          # $t0 = $a0 << 5 = 36 * 32 = 1152
sll $t1, $a0, 2          # $t1 = $a0 << 2 = 36 * 4 = 144
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 1152 + 144 = 1296
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 37 = 1369
addi $a0, $zero, 37      # Set $a0 = 37
sll $t0, $a0, 5          # $t0 = $a0 << 5 = 37 * 32 = 1184
sll $t1, $a0, 3          # $t1 = $a0 << 3 = 37 * 8 = 296
sub $t2, $t1, $a0        # $t2 = $t1 - $a0 = 296 - 37 = 259
sub $t2, $t2, $a0        # $t2 = $t2 - $a0 = 259 - 37 = 222
sub $t2, $t2, $a0        # $t2 = $t2 - $a0 = 222 - 37 = 185
add $t0, $t0, $t2        # $t0 = $t0 + $t2 = 1184 + 185 = 1369
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 38 = 1444
addi $a0, $zero, 38      # Set $a0 = 38
sll $t0, $a0, 5          # $t0 = $a0 << 5 = 38 * 32 = 1216
sll $t1, $a0, 3          # $t1 = $a0 << 3 = 38 * 8 = 304
sub $t2, $t1, $a0        # $t2 = $t1 - $a0 = 304 - 38 = 266
sub $t2, $t2, $a0        # $t2 = $t2 - $a0 = 266 - 38 = 228
add $t0, $t0, $t2        # $t0 = $t0 + $t2 = 1216 + 228 = 1444
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 39 = 1521
addi $a0, $zero, 39      # Set $a0 = 39
sll $t0, $a0, 5          # $t0 = $a0 << 5 = 39 * 32 = 1248
sll $t1, $a0, 4          # $t1 = $a0 << 4 = 39 * 16 = 624
sub $t2, $t0, $t1        # $t2 = $t0 - $t1 = 1248 - 624 = 624
sll $t1, $a0, 3          # $t1 = $a0 << 3 = 39 * 8 = 312
add $t0, $t2, $t1        # $t0 = $t2 + $t1 = 624 + 312 = 936
sll $t1, $a0, 5          # $t1 = $a0 << 5 = 39 * 32 = 1248
sub $t2, $t1, $a0        # $t2 = $t1 - $a0 = 1248 - 39 = 1209
add $t0, $t0, $t2        # $t0 = $t0 + $t2 = 936 + 1209 - 624 = 1521
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 40 = 1600
addi $a0, $zero, 40      # Set $a0 = 40
sll $t0, $a0, 6          # $t0 = $a0 << 6 = 40 * 64 = 2560
sll $t1, $a0, 5          # $t1 = $a0 << 5 = 40 * 32 = 1280
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 2560 - 1280 = 1280
sll $t1, $a0, 3          # $t1 = $a0 << 3 = 40 * 8 = 320
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 1280 + 320 = 1600
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 41 = 1681
addi $a0, $zero, 41      # Set $a0 = 41
sll $t0, $a0, 6          # $t0 = $a0 << 6 = 41 * 64 = 2624
sll $t1, $a0, 5          # $t1 = $a0 << 5 = 41 * 32 = 1312
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 2624 - 1312 = 1312
sll $t1, $a0, 3          # $t1 = $a0 << 3 = 41 * 8 = 328
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 1312 + 328 = 1640
add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 1640 + 41 = 1681
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 42 = 1764
addi $a0, $zero, 42      # Set $a0 = 42
sll $t0, $a0, 6          # $t0 = $a0 << 6 = 42 * 64 = 2688
sll $t1, $a0, 5          # $t1 = $a0 << 5 = 42 * 32 = 1344
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 2688 - 1344 = 1344
sll $t1, $a0, 3          # $t1 = $a0 << 3 = 42 * 8 = 336
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 1344 + 336 = 1680
sll $t1, $a0, 1          # $t1 = $a0 << 1 = 42 * 2 = 84
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 1680 + 84 = 1764
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 43 = 1849
addi $a0, $zero, 43      # Set $a0 = 43
sll $t0, $a0, 6          # $t0 = $a0 << 6 = 43 * 64 = 2752
sll $t1, $a0, 5          # $t1 = $a0 << 5 = 43 * 32 = 1376
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 2752 - 1376 = 1376
sll $t1, $a0, 3          # $t1 = $a0 << 3 = 43 * 8 = 344
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 1376 + 344 = 1720
sll $t1, $a0, 2          # $t1 = $a0 << 2 = 43 * 4 = 172
sub $t2, $t1, $a0        # $t2 = $t1 - $a0 = 172 - 43 = 129
add $t0, $t0, $t2        # $t0 = $t0 + $t2 = 1720 + 129 = 1849
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 44 = 1936
addi $a0, $zero, 44      # Set $a0 = 44
sll $t0, $a0, 6          # $t0 = $a0 << 6 = 44 * 64 = 2816
sll $t1, $a0, 5          # $t1 = $a0 << 5 = 44 * 32 = 1408
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 2816 - 1408 = 1408
sll $t1, $a0, 3          # $t1 = $a0 << 3 = 44 * 8 = 352
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 1408 + 352 = 1760
sll $t1, $a0, 2          # $t1 = $a0 << 2 = 44 * 4 = 176
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 1760 + 176 = 1936
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 45 = 2025
addi $a0, $zero, 45      # Set $a0 = 45
sll $t0, $a0, 6          # $t0 = $a0 << 6 = 45 * 64 = 2880
sll $t1, $a0, 5          # $t1 = $a0 << 5 = 45 * 32 = 1440
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 2880 - 1440 = 1440
sll $t1, $a0, 3          # $t1 = $a0 << 3 = 45 * 8 = 360
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 1440 + 360 = 1800
sll $t1, $a0, 2          # $t1 = $a0 << 2 = 45 * 4 = 180
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 1800 + 180 = 1980
add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 1980 + 45 = 2025
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 46 = 2116
addi $a0, $zero, 46      # Set $a0 = 46
sll $t0, $a0, 6          # $t0 = $a0 << 6 = 46 * 64 = 2944
sll $t1, $a0, 5          # $t1 = $a0 << 5 = 46 * 32 = 1472
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 2944 - 1472 = 1472
sll $t1, $a0, 3          # $t1 = $a0 << 3 = 46 * 8 = 368
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 1472 + 368 = 1840
sll $t1, $a0, 2          # $t1 = $a0 << 2 = 46 * 4 = 184
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 1840 + 184 = 2024
sll $t1, $a0, 1          # $t1 = $a0 << 1 = 46 * 2 = 92
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 2024 + 92 = 2116
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 47 = 2209
addi $a0, $zero, 47      # Set $a0 = 47
sll $t0, $a0, 6          # $t0 = $a0 << 6 = 47 * 64 = 3008
sll $t1, $a0, 5          # $t1 = $a0 << 5 = 47 * 32 = 1504
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 3008 - 1504 = 1504
sll $t1, $a0, 4          # $t1 = $a0 << 4 = 47 * 16 = 752
sub $t2, $t1, $a0        # $t2 = $t1 - $a0 = 752 - 47 = 705
add $t0, $t0, $t2        # $t0 = $t0 + $t2 = 1504 + 705 = 2209
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 48 = 2304
addi $a0, $zero, 48   # Set $a0 = 48
sll $t0, $a0, 6       # $t0 = $a0 << 6 = 48 * 64 = 3072
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 48 * 32 = 1536
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 3072 - 1536 = 1536
sll $t1, $a0, 4       # $t1 = $a0 << 4 = 48 * 16 = 768
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 1536 + 768 = 2304
sw $t0, 0($s0)        # Store result at current address
addi $s0, $s0, 4      # Move to next memory location

# Square of 49 = 2401
addi $a0, $zero, 49   # Set $a0 = 49
sll $t0, $a0, 6       # $t0 = $a0 << 6 = 49 * 64 = 3136
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 49 * 32 = 1568
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 3136 - 1568 = 1568
sll $t1, $a0, 4       # $t1 = $a0 << 4 = 49 * 16 = 784
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 1568 + 784 = 2352
addi $t1, $a0, 0      # $t1 = $a0 = 49
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 2352 + 49 = 2401
sw $t0, 0($s0)        # Store result at current address
addi $s0, $s0, 4      # Move to next memory location

# Square of 50 = 2500
addi $a0, $zero, 50      # Set $a0 = 50
sll $t0, $a0, 6          # $t0 = $a0 << 6 = 50 * 64 = 3200
sll $t1, $a0, 5          # $t1 = $a0 << 5 = 50 * 32 = 1600
sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 3200 - 1600 = 1600
sll $t1, $a0, 4          # $t1 = $a0 << 4 = 50 * 16 = 800
add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 1600 + 800 = 2400
add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 2400 + 50 = 2450
add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 2450 + 50 = 2500
sw $t0, 0($s0)           # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 51 = 2601
addi $a0, $zero, 51   # Set $a0 = 51
sll $t0, $a0, 6       # $t0 = $a0 << 6 = 51 * 64 = 3264
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 51 * 32 = 1632
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 3264 - 1632 = 1632
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 51 * 32 = 1632
sub $t2, $t1, $a0     # $t2 = $t1 - $a0 = 1632 - 51 = 1581
sub $t3, $t2, $a0     # $t3 = $t2 - $a0 = 1581 - 51 = 1530
sub $t4, $t3, $a0     # $t4 = $t3 - $a0 = 1530 - 51 = 1479
sub $t5, $t4, $a0     # $t5 = $t4 - $a0 = 1479 - 51 = 1428
sub $t6, $t5, $a0     # $t6 = $t5 - $a0 = 1428 - 51 = 1377
sub $t7, $t6, $a0     # $t7 = $t6 - $a0 = 1377 - 51 = 1326
sub $t6, $t7, $a0     # $t6 = $t7 - $a0 = 1326 - 51 = 1275
sub $t5, $t6, $a0     # $t5 = $t6 - $a0 = 1275 - 51 = 1224
sub $t4, $t5, $a0     # $t4 = $t5 - $a0 = 1224 - 51 = 1173
sub $t3, $t4, $a0     # $t3 = $t4 - $a0 = 1173 - 51 = 1122
sub $t2, $t3, $a0     # $t2 = $t3 - $a0 = 1122 - 51 = 1071
sub $t1, $t2, $a0     # $t1 = $t2 - $a0 = 1071 - 51 = 1020
sub $t0, $t1, $a0     # $t0 = $t1 - $a0 = 1020 - 51 = 969
add $t0, $t0, $t0     # $t0 = $t0 + $t0 = 969 + 969 = 1938
sll $t1, $a0, 6       # $t1 = $a0 << 6 = 51 * 64 = 3264
sub $t1, $t1, $t0     # $t1 = $t1 - $t0 = 3264 - 1938 = 1326
sll $t2, $a0, 5       # $t2 = $a0 << 5 = 51 * 32 = 1632
sub $t2, $t2, $t1     # $t2 = $t2 - $t1 = 1632 - 1326 = 306
sll $t3, $a0, 3       # $t3 = $a0 << 3 = 51 * 8 = 408
sub $t3, $t3, $t2     # $t3 = $t3 - $t2 = 408 - 306 = 102
sll $t4, $a0, 1       # $t4 = $a0 << 1 = 51 * 2 = 102
add $t0, $t1, $t3     # $t0 = $t1 + $t3 = 1326 + 102 = 1428
add $t0, $t0, $t4     # $t0 = $t0 + $t4 = 1428 + 102 = 1530
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 51 * 32 = 1632
sub $t1, $t1, $a0     # $t1 = $t1 - $a0 = 1632 - 51 = 1581
sub $t1, $t1, $a0     # $t1 = $t1 - $a0 = 1581 - 51 = 1530
sub $t5, $t1, $a0     # $t5 = $t1 - $a0 = 1530 - 51 = 1479
sub $t5, $t5, $a0     # $t5 = $t5 - $a0 = 1479 - 51 = 1428
sub $t5, $t5, $a0     # $t5 = $t5 - $a0 = 1428 - 51 = 1377
add $t0, $t0, $t5     # $t0 = $t0 + $t5 = 1530 + 1377 = 2907
sub $t0, $t0, $a0     # $t0 = $t0 - $a0 = 2907 - 51 = 2856
sub $t0, $t0, $a0     # $t0 = $t0 - $a0 = 2856 - 51 = 2805
sub $t0, $t0, $a0     # $t0 = $t0 - $a0 = 2805 - 51 = 2754
sub $t0, $t0, $a0     # $t0 = $t0 - $a0 = 2754 - 51 = 2703
sub $t0, $t0, $a0     # $t0 = $t0 - $a0 = 2703 - 51 = 2652
sub $t0, $t0, $a0     # $t0 = $t0 - $a0 = 2652 - 51 = 2601
sw $t0, 0($s0)        # Store result at current address
addi $s0, $s0, 4      # Move to next memory location

# Square of 52 = 2704
addi $a0, $zero, 52   # Set $a0 = 52
sll $t0, $a0, 6       # $t0 = $a0 << 6 = 52 * 64 = 3328
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 52 * 32 = 1664
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 3328 - 1664 = 1664
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 52 * 32 = 1664
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 1664 + 1664 = 3328
sll $t1, $a0, 4       # $t1 = $a0 << 4 = 52 * 16 = 832
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 3328 - 832 = 2496
sll $t1, $a0, 3       # $t1 = $a0 << 3 = 52 * 8 = 416
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 2496 - 416 = 2080
sll $t1, $a0, 3       # $t1 = $a0 << 3 = 52 * 8 = 416
add $t1, $t1, $a0     # $t1 = $t1 + $a0 = 416 + 52 = 468
sll $t2, $a0, 2       # $t2 = $a0 << 2 = 52 * 4 = 208
sub $t2, $t1, $t2     # $t2 = $t1 - $t2 = 468 - 208 = 260
sll $t3, $a0, 1       # $t3 = $a0 << 1 = 52 * 2 = 104
add $t3, $t3, $a0     # $t3 = $t3 + $a0 = 104 + 52 = 156
add $t4, $t2, $t3     # $t4 = $t2 + $t3 = 260 + 156 = 416
sll $t5, $a0, 3       # $t5 = $a0 << 3 = 52 * 8 = 416
add $t6, $t0, $t4     # $t6 = $t0 + $t4 = 2080 + 416 = 2496
sll $t7, $a0, 3       # $t7 = $a0 << 3 = 52 * 8 = 416
sub $t7, $t7, $a0     # $t7 = $t7 - $a0 = 416 - 52 = 364
sub $t7, $t7, $a0     # $t7 = $t7 - $a0 = 364 - 52 = 312
sub $t7, $t7, $a0     # $t7 = $t7 - $a0 = 312 - 52 = 260
sub $t7, $t7, $a0     # $t7 = $t7 - $a0 = 260 - 52 = 208
add $t0, $t6, $t7     # $t0 = $t6 + $t7 = 2496 + 208 = 2704
sw $t0, 0($s0)        # Store result at current address
addi $s0, $s0, 4      # Move to next memory location

# Square of 53 = 2809
addi $a0, $zero, 53   # Set $a0 = 53
sll $t0, $a0, 6       # $t0 = $a0 << 6 = 53 * 64 = 3392
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 53 * 32 = 1696
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 3392 - 1696 = 1696
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 53 * 32 = 1696
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 1696 + 1696 = 3392
sll $t1, $a0, 4       # $t1 = $a0 << 4 = 53 * 16 = 848
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 3392 - 848 = 2544
sll $t1, $a0, 3       # $t1 = $a0 << 3 = 53 * 8 = 424
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 2544 - 424 = 2120
sll $t1, $a0, 4       # $t1 = $a0 << 4 = 53 * 16 = 848
sub $t1, $t1, $a0     # $t1 = $t1 - $a0 = 848 - 53 = 795
sub $t1, $t1, $a0     # $t1 = $t1 - $a0 = 795 - 53 = 742
sub $t1, $t1, $a0     # $t1 = $t1 - $a0 = 742 - 53 = 689
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 2120 + 689 = 2809
sw $t0, 0($s0)        # Store result at current address
addi $s0, $s0, 4      # Move to next memory location

# Square of 54 = 2916
addi $a0, $zero, 54   # Set $a0 = 54
sll $t0, $a0, 6       # $t0 = $a0 << 6 = 54 * 64 = 3456
sll $t1, $a0, 4       # $t1 = $a0 << 4 = 54 * 16 = 864
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 3456 - 864 = 2592
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 54 * 32 = 1728
sub $t1, $t1, $a0     # $t1 = $t1 - $a0 = 1728 - 54 = 1674
sub $t1, $t1, $a0     # $t1 = $t1 - $a0 = 1674 - 54 = 1620
sub $t1, $t1, $a0     # $t1 = $t1 - $a0 = 1620 - 54 = 1566
sub $t1, $t1, $a0     # $t1 = $t1 - $a0 = 1566 - 54 = 1512
sub $t1, $t1, $a0     # $t1 = $t1 - $a0 = 1512 - 54 = 1458
sub $t1, $t1, $a0     # $t1 = $t1 - $a0 = 1458 - 54 = 1404
sub $t1, $t1, $a0     # $t1 = $t1 - $a0 = 1404 - 54 = 1350
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 2592 + 1350 = 3942
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 54 * 32 = 1728
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 3942 - 1728 = 2214
sll $t1, $a0, 3       # $t1 = $a0 << 3 = 54 * 8 = 432
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 2214 + 432 = 2646
sll $t1, $a0, 2       # $t1 = $a0 << 2 = 54 * 4 = 216
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 2646 + 216 = 2862
add $t0, $t0, $a0     # $t0 = $t0 + $a0 = 2862 + 54 = 2916
sw $t0, 0($s0)        # Store result at current address
addi $s0, $s0, 4      # Move to next memory location

# Square of 55 = 3025
addi $a0, $zero, 55   # Set $a0 = 55
sll $t0, $a0, 6       # $t0 = $a0 << 6 = 55 * 64 = 3520
sll $t1, $a0, 4       # $t1 = $a0 << 4 = 55 * 16 = 880
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 3520 - 880 = 2640
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 55 * 32 = 1760
sub $t1, $t1, $a0     # $t1 = $t1 - $a0 = 1760 - 55 = 1705
sub $t1, $t1, $a0     # $t1 = $t1 - $a0 = 1705 - 55 = 1650
sub $t1, $t1, $a0     # $t1 = $t1 - $a0 = 1650 - 55 = 1595
sub $t1, $t1, $a0     # $t1 = $t1 - $a0 = 1595 - 55 = 1540
sub $t1, $t1, $a0     # $t1 = $t1 - $a0 = 1540 - 55 = 1485
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 2640 + 1485 = 4125
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 55 * 32 = 1760
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 4125 - 1760 = 2365
sll $t1, $a0, 4       # $t1 = $a0 << 4 = 55 * 16 = 880
sub $t1, $t1, $a0     # $t1 = $t1 - $a0 = 880 - 55 = 825
sub $t1, $t1, $a0     # $t1 = $t1 - $a0 = 825 - 55 = 770
sub $t1, $t1, $a0     # $t1 = $t1 - $a0 = 770 - 55 = 715
sub $t1, $t1, $a0     # $t1 = $t1 - $a0 = 715 - 55 = 660
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 2365 + 660 = 3025
sw $t0, 0($s0)        # Store result at current address
addi $s0, $s0, 4      # Move to next memory location

# Square of 56 = 3136
addi $a0, $zero, 56   # Set $a0 = 56
sll $t0, $a0, 6       # $t0 = $a0 << 6 = 56 * 64 = 3584
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 56 * 32 = 1792
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 3584 - 1792 = 1792
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 56 * 32 = 1792
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 1792 + 1792 = 3584
sll $t1, $a0, 4       # $t1 = $a0 << 4 = 56 * 16 = 896
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 3584 - 896 = 2688
sll $t1, $a0, 3       # $t1 = $a0 << 3 = 56 * 8 = 448
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 2688 + 448 = 3136
sw $t0, 0($s0)        # Store result at current address
addi $s0, $s0, 4      # Move to next memory location

# Square of 57 = 3249
addi $a0, $zero, 57   # Set $a0 = 57
sll $t0, $a0, 6       # $t0 = $a0 << 6 = 57 * 64 = 3648
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 57 * 32 = 1824
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 3648 - 1824 = 1824
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 57 * 32 = 1824
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 1824 + 1824 = 3648
sll $t1, $a0, 4       # $t1 = $a0 << 4 = 57 * 16 = 912
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 3648 - 912 = 2736
sll $t1, $a0, 3       # $t1 = $a0 << 3 = 57 * 8 = 456
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 2736 + 456 = 3192
add $t0, $t0, $a0     # $t0 = $t0 + $a0 = 3192 + 57 = 3249
sw $t0, 0($s0)        # Store result at current address
addi $s0, $s0, 4      # Move to next memory location

# Square of 58 = 3364
addi $a0, $zero, 58   # Set $a0 = 58
sll $t0, $a0, 6       # $t0 = $a0 << 6 = 58 * 64 = 3712
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 58 * 32 = 1856
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 3712 - 1856 = 1856
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 58 * 32 = 1856
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 1856 + 1856 = 3712
sll $t1, $a0, 4       # $t1 = $a0 << 4 = 58 * 16 = 928
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 3712 - 928 = 2784
sll $t1, $a0, 3       # $t1 = $a0 << 3 = 58 * 8 = 464
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 2784 + 464 = 3248
sll $t1, $a0, 1       # $t1 = $a0 << 1 = 58 * 2 = 116
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 3248 + 116 = 3364
sw $t0, 0($s0)        # Store result at current address
addi $s0, $s0, 4      # Move to next memory location

# Square of 59 = 3481
addi $a0, $zero, 59   # Set $a0 = 59
sll $t0, $a0, 6       # $t0 = $a0 << 6 = 59 * 64 = 3776
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 59 * 32 = 1888
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 3776 - 1888 = 1888
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 59 * 32 = 1888
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 1888 + 1888 = 3776
sll $t1, $a0, 4       # $t1 = $a0 << 4 = 59 * 16 = 944
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 3776 - 944 = 2832
sll $t1, $a0, 3       # $t1 = $a0 << 3 = 59 * 8 = 472
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 2832 + 472 = 3304
sll $t1, $a0, 1       # $t1 = $a0 << 1 = 59 * 2 = 118
add $t1, $t1, $a0     # $t1 = $t1 + $a0 = 118 + 59 = 177
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 3304 + 177 = 3481
sw $t0, 0($s0)        # Store result at current address
addi $s0, $s0, 4      # Move to next memory location

# Square of 60 = 3600
addi $a0, $zero, 60   # Set $a0 = 60
sll $t0, $a0, 6       # $t0 = $a0 << 6 = 60 * 64 = 3840
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 60 * 32 = 1920
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 3840 - 1920 = 1920
sll $t1, $a0, 5       # $t1 = $a0 << 5 = 60 * 32 = 1920
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 1920 + 1920 = 3840
sll $t1, $a0, 4       # $t1 = $a0 << 4 = 60 * 16 = 960
sub $t0, $t0, $t1     # $t0 = $t0 - $t1 = 3840 - 960 = 2880
sll $t1, $a0, 3       # $t1 = $a0 << 3 = 60 * 8 = 480
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 2880 + 480 = 3360
sll $t1, $a0, 2       # $t1 = $a0 << 2 = 60 * 4 = 240
add $t0, $t0, $t1     # $t0 = $t0 + $t1 = 3360 + 240 = 3600
sw $t0, 0($s0)        # Store result at current address
addi $s0, $s0, 4      # Move to next memory location

# Square of 61 = 3721
addi $a0, $zero, 61   # Set $a0 = 61
sll $t0, $a0, 6       # $t0 = 61 * 64 = 3904
sll $t1, $a0, 5       # $t1 = 61 * 32 = 1952
sub $t0, $t0, $t1     # $t0 = 3904 - 1952 = 1952
sll $t1, $a0, 5       # $t1 = 61 * 32 = 1952
add $t0, $t0, $t1     # $t0 = 1952 + 1952 = 3904
sll $t1, $a0, 4       # $t1 = 61 * 16 = 976
sub $t0, $t0, $t1     # $t0 = 3904 - 976 = 2928
sll $t1, $a0, 3       # $t1 = 61 * 8 = 488
add $t0, $t0, $t1     # $t0 = 2928 + 488 = 3416
sll $t1, $a0, 2       # $t1 = 61 * 4 = 244
add $t0, $t0, $t1     # $t0 = 3416 + 244 = 3660
add $t0, $t0, $a0     # $t0 = 3660 + 61 = 3721
sw $t0, 0($s0)        # Store result
addi $s0, $s0, 4      # Move to next memory location

# Square of 62 = 3844
addi $a0, $zero, 62   # Set $a0 = 62
sll $t0, $a0, 6       # $t0 = 62 * 64 = 3968
sll $t1, $a0, 5       # $t1 = 62 * 32 = 1984
sub $t0, $t0, $t1     # $t0 = 3968 - 1984 = 1984
sll $t1, $a0, 5       # $t1 = 62 * 32 = 1984
add $t0, $t0, $t1     # $t0 = 1984 + 1984 = 3968
sll $t1, $a0, 4       # $t1 = 62 * 16 = 992
sub $t0, $t0, $t1     # $t0 = 3968 - 992 = 2976
sll $t1, $a0, 3       # $t1 = 62 * 8 = 496
add $t0, $t0, $t1     # $t0 = 2976 + 496 = 3472
sll $t1, $a0, 2       # $t1 = 62 * 4 = 248
add $t0, $t0, $t1     # $t0 = 3472 + 248 = 3720
sll $t1, $a0, 1       # $t1 = 62 * 2 = 124
add $t0, $t0, $t1     # $t0 = 3720 + 124 = 3844
sw $t0, 0($s0)        # Store result
addi $s0, $s0, 4      # Move to next memory location

# Square of 63 = 3969
addi $a0, $zero, 63   # Set $a0 = 63
sll $t0, $a0, 6       # $t0 = 63 * 64 = 4032
sll $t1, $a0, 5       # $t1 = 63 * 32 = 2016
sub $t0, $t0, $t1     # $t0 = 4032 - 2016 = 2016
sll $t1, $a0, 5       # $t1 = 63 * 32 = 2016
add $t0, $t0, $t1     # $t0 = 2016 + 2016 = 4032
sll $t1, $a0, 4       # $t1 = 63 * 16 = 1008
sub $t0, $t0, $t1     # $t0 = 4032 - 1008 = 3024
sll $t1, $a0, 3       # $t1 = 63 * 8 = 504
add $t0, $t0, $t1     # $t0 = 3024 + 504 = 3528
sll $t1, $a0, 2       # $t1 = 63 * 4 = 252
add $t0, $t0, $t1     # $t0 = 3528 + 252 = 3780
sll $t1, $a0, 1       # $t1 = 63 * 2 = 126
add $t0, $t0, $t1     # $t0 = 3780 + 126 = 3906
add $t0, $t0, $a0     # $t0 = 3906 + 63 = 3969
sw $t0, 0($s0)        # Store result
addi $s0, $s0, 4      # Move to next memory location

# Square of 64 = 4096
addi $a0, $zero, 64   # Set $a0 = 64
sll $t0, $a0, 6       # $t0 = 64 * 64 = 4096
sll $t1, $a0, 5       # $t1 = 64 * 32 = 2048
sub $t0, $t0, $t1     # $t0 = 4096 - 2048 = 2048
sll $t1, $a0, 5       # $t1 = 64 * 32 = 2048
add $t0, $t0, $t1     # $t0 = 2048 + 2048 = 4096
sll $t1, $a0, 4       # $t1 = 64 * 16 = 1024
sub $t0, $t0, $t1     # $t0 = 4096 - 1024 = 3072
sll $t1, $a0, 3       # $t1 = 64 * 8 = 512
add $t0, $t0, $t1     # $t0 = 3072 + 512 = 3584
sll $t1, $a0, 3       # $t1 = 64 * 8 = 512
add $t0, $t0, $t1     # $t0 = 3584 + 512 = 4096
sw $t0, 0($s0)        # Store result
addi $s0, $s0, 4      # Move to next memory location

# Square of 65 = 4225
addi $a0, $zero, 65      # $a0 = 65
sll  $t0, $a0, 6         # t0 = 65 * 64 = 4160
sll  $t1, $a0, 5         # t1 = 65 * 32 = 2080
sub  $t0, $t0, $t1       # t0 = 4160 - 2080 = 2080
sll  $t1, $a0, 5         # t1 = 65 * 32 = 2080
add  $t0, $t0, $t1       # t0 = 2080 + 2080 = 4160
sll  $t1, $a0, 4         # t1 = 65 * 16 = 1040
sub  $t0, $t0, $t1       # t0 = 4160 - 1040 = 3120
sll  $t1, $a0, 3         # t1 = 65 *  8 =  520
add  $t0, $t0, $t1       # t0 = 3120 +  520 = 3640
sll  $t1, $a0, 3         # t1 = 65 *  8 =  520
add  $t0, $t0, $t1       # t0 = 3640 +  520 = 4160
add  $t0, $t0, $a0       # t0 = 4160 +   65 = 4225
sw   $t0, 0($s0)         # store 4225
addi $s0, $s0, 4         # advance pointer

# Square of 66 = 4356
addi $a0, $zero, 66      # $a0 = 66
sll  $t0, $a0, 6         # t0 = 66 * 64 = 4224
sll  $t1, $a0, 5         # t1 = 66 * 32 = 2112
sub  $t0, $t0, $t1       # t0 = 4224 - 2112 = 2112
sll  $t1, $a0, 5         # t1 = 66 * 32 = 2112
add  $t0, $t0, $t1       # t0 = 2112 + 2112 = 4224
sll  $t1, $a0, 4         # t1 = 66 * 16 = 1056
sub  $t0, $t0, $t1       # t0 = 4224 - 1056 = 3168
sll  $t1, $a0, 3         # t1 = 66 *  8 =  528
add  $t0, $t0, $t1       # t0 = 3168 +  528 = 3696
sll  $t1, $a0, 3         # t1 = 66 *  8 =  528
add  $t0, $t0, $t1       # t0 = 3696 +  528 = 4224
sll  $t1, $a0, 1         # t1 = 66 *  2 =  132
add  $t0, $t0, $t1       # t0 = 4224 +  132 = 4356
sw   $t0, 0($s0)         # store 4356
addi $s0, $s0, 4         # advance pointer

# Square of 67 = 4489
addi $a0, $zero, 67      # $a0 = 67
sll  $t0, $a0, 6         # t0 = 67 * 64 = 4288
sll  $t1, $a0, 5         # t1 = 67 * 32 = 2144
sub  $t0, $t0, $t1       # t0 = 4288 - 2144 = 2144
sll  $t1, $a0, 5         # t1 = 67 * 32 = 2144
add  $t0, $t0, $t1       # t0 = 2144 + 2144 = 4288
sll  $t1, $a0, 4         # t1 = 67 * 16 = 1072
sub  $t0, $t0, $t1       # t0 = 4288 - 1072 = 3216
sll  $t1, $a0, 3         # t1 = 67 *  8 =  536
add  $t0, $t0, $t1       # t0 = 3216 +  536 = 3752
sll  $t1, $a0, 3         # t1 = 67 *  8 =  536
add  $t0, $t0, $t1       # t0 = 3752 +  536 = 4288
sll  $t1, $a0, 1         # t1 = 67 *  2 =  134
add  $t0, $t0, $t1       # t0 = 4288 +  134 = 4422
add  $t0, $t0, $a0       # t0 = 4422 +   67 = 4489
sw   $t0, 0($s0)         # store 4489
addi $s0, $s0, 4         # advance pointer

# Square of 68 = 4624
addi $a0, $zero, 68      # $a0 = 68
sll  $t0, $a0, 6         # t0 = 68 * 64 = 4352
sll  $t1, $a0, 5         # t1 = 68 * 32 = 2176
sub  $t0, $t0, $t1       # t0 = 4352 - 2176 = 2176
sll  $t1, $a0, 5         # t1 = 68 * 32 = 2176
add  $t0, $t0, $t1       # t0 = 2176 + 2176 = 4352
sll  $t1, $a0, 4         # t1 = 68 * 16 = 1088
sub  $t0, $t0, $t1       # t0 = 4352 - 1088 = 3264
sll  $t1, $a0, 3         # t1 = 68 *  8 =  544
add  $t0, $t0, $t1       # t0 = 3264 +  544 = 3808
sll  $t1, $a0, 3         # t1 = 68 *  8 =  544
add  $t0, $t0, $t1       # t0 = 3808 +  544 = 4352
sll  $t1, $a0, 2         # t1 = 68 *  4 =  272
add  $t0, $t0, $t1       # t0 = 4352 +  272 = 4624
sw   $t0, 0($s0)         # store 4624
addi $s0, $s0, 4         # advance pointer

# Square of 69 = 4761
addi $a0, $zero, 69      # $a0 = 69
sll  $t0, $a0, 6         # t0 = 69 * 64 = 4416
sll  $t1, $a0, 5         # t1 = 69 * 32 = 2208
sub  $t0, $t0, $t1       # t0 = 4416 - 2208 = 2208
sll  $t1, $a0, 5         # t1 = 69 * 32 = 2208
add  $t0, $t0, $t1       # t0 = 2208 + 2208 = 4416
sll  $t1, $a0, 4         # t1 = 69 * 16 = 1104
sub  $t0, $t0, $t1       # t0 = 4416 - 1104 = 3312
sll  $t1, $a0, 3         # t1 = 69 *  8 =  552
add  $t0, $t0, $t1       # t0 = 3312 +  552 = 3864
sll  $t1, $a0, 3         # t1 = 69 *  8 =  552
add  $t0, $t0, $t1       # t0 = 3864 +  552 = 4416
sll  $t1, $a0, 2         # t1 = 69 *  4 =  276
add  $t0, $t0, $t1       # t0 = 4416 +  276 = 4692
add  $t0, $t0, $a0       # t0 = 4692 +   69 = 4761
sw   $t0, 0($s0)         # store 4761
addi $s0, $s0, 4         # advance pointer

# Square of 70 = 4900
addi $a0, $zero, 70      # $a0 = 70
sll  $t0, $a0, 6         # t0 = 70 * 64 = 4480
sll  $t1, $a0, 5         # t1 = 70 * 32 = 2240
sub  $t0, $t0, $t1       # t0 = 4480 - 2240 = 2240
sll  $t1, $a0, 5         # t1 = 70 * 32 = 2240
add  $t0, $t0, $t1       # t0 = 2240 + 2240 = 4480
sll  $t1, $a0, 4         # t1 = 70 * 16 = 1120
sub  $t0, $t0, $t1       # t0 = 4480 - 1120 = 3360
sll  $t1, $a0, 3         # t1 = 70 *  8 =  560
add  $t0, $t0, $t1       # t0 = 3360 +  560 = 3920
sll  $t1, $a0, 3         # t1 = 70 *  8 =  560
add  $t0, $t0, $t1       # t0 = 3920 +  560 = 4480
sll  $t1, $a0, 2         # t1 = 70 *  4 =  280
add  $t0, $t0, $t1       # t0 = 4480 +  280 = 4760
sll  $t1, $a0, 1         # t1 = 70 *  2 =  140
add  $t0, $t0, $t1       # t0 = 4760 +  140 = 4900
sw   $t0, 0($s0)         # store 4900
addi $s0, $s0, 4         # advance pointer

# Square of 71 = 5041
addi $a0, $zero, 71      # $a0 = 71
sll  $t0, $a0, 6         # t0 = 71 * 64 = 4544
sll  $t1, $a0, 5         # t1 = 71 * 32 = 2272
sub  $t0, $t0, $t1       # t0 = 4544 - 2272 = 2272
sll  $t1, $a0, 5         # t1 = 71 * 32 = 2272
add  $t0, $t0, $t1       # t0 = 2272 + 2272 = 4544
sll  $t1, $a0, 4         # t1 = 71 * 16 = 1136
sub  $t0, $t0, $t1       # t0 = 4544 - 1136 = 3408
sll  $t1, $a0, 3         # t1 = 71 *  8 =  568
add  $t0, $t0, $t1       # t0 = 3408 +  568 = 3976
sll  $t1, $a0, 3         # t1 = 71 *  8 =  568
add  $t0, $t0, $t1       # t0 = 3976 +  568 = 4544
sll  $t1, $a0, 2         # t1 = 71 *  4 =  284
add  $t0, $t0, $t1       # t0 = 4544 +  284 = 4828
sll  $t1, $a0, 1         # t1 = 71 *  2 =  142
add  $t0, $t0, $t1       # t0 = 4828 +  142 = 4970
add  $t0, $t0, $a0       # t0 = 4970 +   71 = 5041
sw   $t0, 0($s0)         # store 5041
addi $s0, $s0, 4         # advance pointer

# Square of 72 = 5184
addi $a0, $zero, 72      # Set $a0 = 72
sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 72 * 64 = 4608
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 72 * 32 = 2304
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 4608 - 2304 = 2304
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 72 * 32 = 2304
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2304 + 2304 = 4608
sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 72 * 16 = 1152
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 4608 - 1152 = 3456
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 72 * 8 = 576
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 3456 + 576 = 4032
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 72 * 8 = 576
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4032 + 576 = 4608
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 72 * 8 = 576
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4608 + 576 = 5184
sw   $t0, 0($s0)         # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 73 = 5329
addi $a0, $zero, 73      # Set $a0 = 73
sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 73 * 64 = 4672
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 73 * 32 = 2336
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 4672 - 2336 = 2336
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 73 * 32 = 2336
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2336 + 2336 = 4672
sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 73 * 16 = 1168
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 4672 - 1168 = 3504
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 73 * 8 = 584
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 3504 + 584 = 4088
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 73 * 8 = 584
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4088 + 584 = 4672
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 73 * 8 = 584
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4672 + 584 = 5256
add  $t0, $t0, $a0       # $t0 = $t0 + $a0 = 5256 + 73 = 5329
sw   $t0, 0($s0)         # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 74 = 5476
addi $a0, $zero, 74      # Set $a0 = 74
sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 74 * 64 = 4736
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 74 * 32 = 2368
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 4736 - 2368 = 2368
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 74 * 32 = 2368
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2368 + 2368 = 4736
sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 74 * 16 = 1184
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 4736 - 1184 = 3552
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 74 * 8 = 592
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 3552 + 592 = 4144
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 74 * 8 = 592
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4144 + 592 = 4736
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 74 * 8 = 592
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4736 + 592 = 5328
sll  $t1, $a0, 1         # $t1 = $a0 << 1 = 74 * 2 = 148
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5328 + 148 = 5476
sw   $t0, 0($s0)         # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 75 = 5625
addi $a0, $zero, 75      # Set $a0 = 75
sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 75 * 64 = 4800
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 75 * 32 = 2400
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 4800 - 2400 = 2400
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 75 * 32 = 2400
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2400 + 2400 = 4800
sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 75 * 16 = 1200
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 4800 - 1200 = 3600
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 75 * 8 = 600
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 3600 + 600 = 4200
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 75 * 8 = 600
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4200 + 600 = 4800
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 75 * 8 = 600
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4800 + 600 = 5400
sll  $t1, $a0, 2         # $t1 = $a0 << 2 = 75 * 4 = 300
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5400 + 300 = 5700
add  $t0, $t0, $a0       # $t0 = $t0 + $a0 = 5700 + 75 = 5625
sw   $t0, 0($s0)         # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 76 = 5776
addi $a0, $zero, 76      # Set $a0 = 76
sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 76 * 64 = 4864
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 76 * 32 = 2432
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 4864 - 2432 = 2432
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 76 * 32 = 2432
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2432 + 2432 = 4864
sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 76 * 16 = 1216
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 4864 - 1216 = 3648
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 76 * 8 = 608
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 3648 + 608 = 4256
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 76 * 8 = 608
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4256 + 608 = 4864
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 76 * 8 = 608
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4864 + 608 = 5472
sll  $t1, $a0, 2         # $t1 = $a0 << 2 = 76 * 4 = 304
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5472 + 304 = 5776
sw   $t0, 0($s0)         # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 77 = 5929
addi $a0, $zero, 77      # Set $a0 = 77
sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 77 * 64 = 4928
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 77 * 32 = 2464
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 4928 - 2464 = 2464
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 77 * 32 = 2464
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2464 + 2464 = 4928
sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 77 * 16 = 1232
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 4928 - 1232 = 3696
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 77 * 8 = 616
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 3696 + 616 = 4312
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 77 * 8 = 616
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4312 + 616 = 4928
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 77 * 8 = 616
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4928 + 616 = 5544
sll  $t1, $a0, 2         # $t1 = $a0 << 2 = 77 * 4 = 308
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5544 + 308 = 5852
add  $t0, $t0, $a0       # $t0 = $t0 + $a0 = 5852 + 77 = 5929
sw   $t0, 0($s0)         # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 78 = 6084
addi $a0, $zero, 78      # Set $a0 = 78
sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 78 * 64 = 4992
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 78 * 32 = 2496
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 4992 - 2496 = 2496
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 78 * 32 = 2496
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2496 + 2496 = 4992
sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 78 * 16 = 1248
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 4992 - 1248 = 3744
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 78 * 8 = 624
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 3744 + 624 = 4368
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 78 * 8 = 624
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4368 + 624 = 4992
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 78 * 8 = 624
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4992 + 624 = 5616
sll  $t1, $a0, 2         # $t1 = $a0 << 2 = 78 * 4 = 312
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5616 + 312 = 5928
sll  $t1, $a0, 1         # $t1 = $a0 << 1 = 78 * 2 = 156
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5928 + 156 = 6084
sw   $t0, 0($s0)         # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 79 = 6241
addi $a0, $zero, 79      # Set $a0 = 79
sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 79 * 64 = 5056
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 79 * 32 = 2528
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5056 - 2528 = 2528
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 79 * 32 = 2528
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2528 + 2528 = 5056
sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 79 * 16 = 1264
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5056 - 1264 = 3792
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 79 * 8 = 632
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 3792 + 632 = 4424
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 79 * 8 = 632
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4424 + 632 = 5056
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 79 * 8 = 632
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5056 + 632 = 5688
sll  $t1, $a0, 2         # $t1 = $a0 << 2 = 79 * 4 = 316
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5688 + 316 = 6004
sll  $t1, $a0, 1         # $t1 = $a0 << 1 = 79 * 2 = 158
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6004 + 158 = 6162
add  $t0, $t0, $a0       # $t0 = $t0 + $a0 = 6162 + 79 = 6241
sw   $t0, 0($s0)         # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 80 = 6400
addi $a0, $zero, 80      # Set $a0 = 80
sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 80 * 64 = 5120
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 80 * 32 = 2560
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5120 - 2560 = 2560
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 80 * 32 = 2560
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2560 + 2560 = 5120
sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 80 * 16 = 1280
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5120 - 1280 = 3840
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 80 * 8 = 640
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 3840 + 640 = 4480
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 80 * 8 = 640
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4480 + 640 = 5120
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 80 * 8 = 640
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5120 + 640 = 5760
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 80 * 8 = 640
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5760 + 640 = 6400
sw   $t0, 0($s0)         # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 81 = 6561
addi $a0, $zero, 81      # Set $a0 = 81
sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 81 * 64 = 5184
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 81 * 32 = 2592
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5184 - 2592 = 2592
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 81 * 32 = 2592
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2592 + 2592 = 5184
sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 81 * 16 = 1296
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5184 - 1296 = 3888
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 81 * 8 = 648
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 3888 + 648 = 4536
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 81 * 8 = 648
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4536 + 648 = 5184
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 81 * 8 = 648
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5184 + 648 = 5832
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 81 * 8 = 648
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5832 + 648 = 6480
add  $t0, $t0, $a0       # $t0 = $t0 + $a0 = 6480 + 81 = 6561
sw   $t0, 0($s0)         # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 82 = 6724
addi $a0, $zero, 82      # Set $a0 = 82
sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 82 * 64 = 5248
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 82 * 32 = 2624
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5248 - 2624 = 2624
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 82 * 32 = 2624
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2624 + 2624 = 5248
sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 82 * 16 = 1312
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5248 - 1312 = 3936
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 82 * 8 = 656
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 3936 + 656 = 4592
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 82 * 8 = 656
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4592 + 656 = 5248
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 82 * 8 = 656
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5248 + 656 = 5904
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 82 * 8 = 656
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5904 + 656 = 6560
sll  $t1, $a0, 1         # $t1 = $a0 << 1 = 82 * 2 = 164
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6560 + 164 = 6724
sw   $t0, 0($s0)         # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 83 = 6889
addi $a0, $zero, 83      # Set $a0 = 83
sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 83 * 64 = 5312
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 83 * 32 = 2656
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5312 - 2656 = 2656
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 83 * 32 = 2656
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2656 + 2656 = 5312
sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 83 * 16 = 1328
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5312 - 1328 = 3984
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 83 * 8 = 664
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 3984 + 664 = 4648
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 83 * 8 = 664
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4648 + 664 = 5312
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 83 * 8 = 664
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5312 + 664 = 5976
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 83 * 8 = 664
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5976 + 664 = 6640
sll  $t1, $a0, 1         # $t1 = $a0 << 1 = 83 * 2 = 166
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6640 + 166 = 6806
add  $t0, $t0, $a0       # $t0 = $t0 + $a0 = 6806 + 83 = 6889
sw   $t0, 0($s0)         # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# Square of 84 = 7056
addi $a0, $zero, 84      # Set $a0 = 84
sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 84 * 64 = 5376
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 84 * 32 = 2688
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5376 - 2688 = 2688
sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 84 * 32 = 2688
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2688 + 2688 = 5376
sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 84 * 16 = 1344
sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5376 - 1344 = 4032
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 84 * 8 = 672
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4032 + 672 = 4704
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 84 * 8 = 672
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4704 + 672 = 5376
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 84 * 8 = 672
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5376 + 672 = 6048
sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 84 * 8 = 672
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6048 + 672 = 6720
sll  $t1, $a0, 2         # $t1 = $a0 << 2 = 84 * 4 = 336
add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6720 + 336 = 7056
sw   $t0, 0($s0)         # Store result at current address
addi $s0, $s0, 4         # Move to next memory location

# # Square of 85 = 7225
# addi $a0, $zero, 85      # Set $a0 = 85
# sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 85 * 64 = 5440
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 85 * 32 = 2720
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5440 - 2720 = 2720
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 85 * 32 = 2720
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2720 + 2720 = 5440
# sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 85 * 16 = 1360
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5440 - 1360 = 4080
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 85 * 8 = 680
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4080 + 680 = 4760
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 85 * 8 = 680
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4760 + 680 = 5440
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 85 * 8 = 680
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5440 + 680 = 6120
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 85 * 8 = 680
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6120 + 680 = 6800
# sll  $t1, $a0, 2         # $t1 = $a0 << 2 = 85 * 4 = 340
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6800 + 340 = 7140
# add  $t0, $t0, $a0       # $t0 = $t0 + $a0 = 7140 + 85 = 7225
# sw   $t0, 0($s0)         # Store result at current address
# addi $s0, $s0, 4         # Move to next memory location

# # Square of 86 = 7396
# addi $a0, $zero, 86      # Set $a0 = 86
# sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 86 * 64 = 5504
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 86 * 32 = 2752
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5504 - 2752 = 2752
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 86 * 32 = 2752
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2752 + 2752 = 5504
# sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 86 * 16 = 1376
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5504 - 1376 = 4128
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 86 * 8 = 688
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4128 + 688 = 4816
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 86 * 8 = 688
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4816 + 688 = 5504
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 86 * 8 = 688
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5504 + 688 = 6192
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 86 * 8 = 688
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6192 + 688 = 6880
# sll  $t1, $a0, 2         # $t1 = $a0 << 2 = 86 * 4 = 344
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6880 + 344 = 7224
# sll  $t1, $a0, 1         # $t1 = $a0 << 1 = 86 * 2 = 172
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 7224 + 172 = 7396
# sw   $t0, 0($s0)         # Store result at current address
# addi $s0, $s0, 4         # Move to next memory location

# # Square of 87 = 7569
# addi $a0, $zero, 87      # Set $a0 = 87
# sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 87 * 64 = 5568
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 87 * 32 = 2784
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5568 - 2784 = 2784
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 87 * 32 = 2784
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2784 + 2784 = 5568
# sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 87 * 16 = 1392
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5568 - 1392 = 4176
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 87 * 8 = 696
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4176 + 696 = 4872
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 87 * 8 = 696
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4872 + 696 = 5568
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 87 * 8 = 696
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5568 + 696 = 6264
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 87 * 8 = 696
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6264 + 696 = 6960
# sll  $t1, $a0, 2         # $t1 = $a0 << 2 = 87 * 4 = 348
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6960 + 348 = 7308
# sll  $t1, $a0, 1         # $t1 = $a0 << 1 = 87 * 2 = 174
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 7308 + 174 = 7482
# add  $t0, $t0, $a0       # $t0 = $t0 + $a0 = 7482 + 87 = 7569
# sw   $t0, 0($s0)         # Store result at current address
# addi $s0, $s0, 4         # Move to next memory location

# # Square of 88 = 7744
# addi $a0, $zero, 88      # Set $a0 = 88
# sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 88 * 64 = 5632
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 88 * 32 = 2816
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5632 - 2816 = 2816
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 88 * 32 = 2816
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2816 + 2816 = 5632
# sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 88 * 16 = 1408
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5632 - 1408 = 4224
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 88 * 8 = 704
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4224 + 704 = 4928
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 88 * 8 = 704
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4928 + 704 = 5632
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 88 * 8 = 704
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5632 + 704 = 6336
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 88 * 8 = 704
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6336 + 704 = 7040
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 88 * 8 = 704
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 7040 + 704 = 7744
# sw   $t0, 0($s0)         # Store result at current address
# addi $s0, $s0, 4         # Move to next memory location

# # Square of 89 = 7921
# addi $a0, $zero, 89      # Set $a0 = 89
# sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 89 * 64 = 5696
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 89 * 32 = 2848
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5696 - 2848 = 2848
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 89 * 32 = 2848
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2848 + 2848 = 5696
# sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 89 * 16 = 1424
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5696 - 1424 = 4272
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 89 * 8 = 712
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4272 + 712 = 4984
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 89 * 8 = 712
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4984 + 712 = 5696
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 89 * 8 = 712
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5696 + 712 = 6408
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 89 * 8 = 712
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6408 + 712 = 7120
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 89 * 8 = 712
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 7120 + 712 = 7832
# add  $t0, $t0, $a0       # $t0 = $t0 + $a0 = 7832 + 89 = 7921
# sw   $t0, 0($s0)         # Store result at current address
# addi $s0, $s0, 4         # Move to next memory location

# # Square of 90 = 8100
# addi $a0, $zero, 90      # Set $a0 = 90
# sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 90 * 64 = 5760
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 90 * 32 = 2880
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5760 - 2880 = 2880
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 90 * 32 = 2880
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2880 + 2880 = 5760
# sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 90 * 16 = 1440
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5760 - 1440 = 4320
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 90 * 8 = 720
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4320 + 720 = 5040
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 90 * 8 = 720
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5040 + 720 = 5760
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 90 * 8 = 720
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5760 + 720 = 6480
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 90 * 8 = 720
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6480 + 720 = 7200
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 90 * 8 = 720
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 7200 + 720 = 7920
# sll  $t1, $a0, 2         # $t1 = $a0 << 2 = 90 * 4 = 360
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 7920 + 360 = 8280
# sw   $t0, 0($s0)         # Store result at current address
# addi $s0, $s0, 4         # Move to next memory location

# # Square of 91 = 8281
# addi $a0, $zero, 91      # Set $a0 = 91
# sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 91 * 64 = 5824
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 91 * 32 = 2912
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5824 - 2912 = 2912
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 91 * 32 = 2912
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2912 + 2912 = 5824
# sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 91 * 16 = 1456
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5824 - 1456 = 4368
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 91 * 8 = 728
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4368 + 728 = 5096
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 91 * 8 = 728
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5096 + 728 = 5824
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 91 * 8 = 728
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5824 + 728 = 6552
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 91 * 8 = 728
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6552 + 728 = 7280
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 91 * 8 = 728
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 7280 + 728 = 8008
# sll  $t1, $a0, 2         # $t1 = $a0 << 2 = 91 * 4 = 364
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 8008 + 364 = 8372
# add  $t0, $t0, $a0       # $t0 = $t0 + $a0 = 8372 + 91 = 8463
# sw   $t0, 0($s0)         # Store result at current address
# addi $s0, $s0, 4         # Move to next memory location

# # Square of 92 = 8464
# addi $a0, $zero, 92      # Set $a0 = 92
# sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 92 * 64 = 5888
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 92 * 32 = 2944
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5888 - 2944 = 2944
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 92 * 32 = 2944
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2944 + 2944 = 5888
# sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 92 * 16 = 1472
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5888 - 1472 = 4416
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 92 * 8 = 736
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4416 + 736 = 5152
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 92 * 8 = 736
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5152 + 736 = 5888
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 92 * 8 = 736
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5888 + 736 = 6624
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 92 * 8 = 736
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6624 + 736 = 7360
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 92 * 8 = 736
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 7360 + 736 = 8096
# sll  $t1, $a0, 2         # $t1 = $a0 << 2 = 92 * 4 = 368
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 8096 + 368 = 8464
# sw   $t0, 0($s0)         # Store result at current address
# addi $s0, $s0, 4         # Move to next memory location

# # Square of 93 = 8649
# addi $a0, $zero, 93      # Set $a0 = 93
# sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 93 * 64 = 5952
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 93 * 32 = 2976
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5952 - 2976 = 2976
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 93 * 32 = 2976
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 2976 + 2976 = 5952
# sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 93 * 16 = 1488
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 5952 - 1488 = 4464
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 93 * 8 = 744
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4464 + 744 = 5208
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 93 * 8 = 744
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5208 + 744 = 5952
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 93 * 8 = 744
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5952 + 744 = 6696
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 93 * 8 = 744
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6696 + 744 = 7440
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 93 * 8 = 744
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 7440 + 744 = 8184
# sll  $t1, $a0, 2         # $t1 = $a0 << 2 = 93 * 4 = 372
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 8184 + 372 = 8556
# add  $t0, $t0, $a0       # $t0 = $t0 + $a0 = 8556 + 93 = 8649
# sw   $t0, 0($s0)         # Store result at current address
# addi $s0, $s0, 4         # Move to next memory location

# # Square of 94 = 8836
# addi $a0, $zero, 94      # Set $a0 = 94
# sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 94 * 64 = 6016
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 94 * 32 = 3008
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 6016 - 3008 = 3008
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 94 * 32 = 3008
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 3008 + 3008 = 6016
# sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 94 * 16 = 1504
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 6016 - 1504 = 4512
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 94 * 8 = 752
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4512 + 752 = 5264
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 94 * 8 = 752
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5264 + 752 = 6016
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 94 * 8 = 752
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6016 + 752 = 6768
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 94 * 8 = 752
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6768 + 752 = 7520
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 94 * 8 = 752
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 7520 + 752 = 8272
# sll  $t1, $a0, 2         # $t1 = $a0 << 2 = 94 * 4 = 376
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 8272 + 376 = 8648
# sll  $t1, $a0, 1         # $t1 = $a0 << 1 = 94 * 2 = 188
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 8648 + 188 = 8836
# sw   $t0, 0($s0)         # Store result at current address
# addi $s0, $s0, 4         # Move to next memory location

# # Square of 95 = 9025
# addi $a0, $zero, 95      # Set $a0 = 95
# sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 95 * 64 = 6080
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 95 * 32 = 3040
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 6080 - 3040 = 3040
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 95 * 32 = 3040
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 3040 + 3040 = 6080
# sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 95 * 16 = 1520
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 6080 - 1520 = 4560
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 95 * 8 = 760
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4560 + 760 = 5320
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 95 * 8 = 760
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5320 + 760 = 6080
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 95 * 8 = 760
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6080 + 760 = 6840
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 95 * 8 = 760
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6840 + 760 = 7600
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 95 * 8 = 760
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 7600 + 760 = 8360
# sll  $t1, $a0, 2         # $t1 = $a0 << 2 = 95 * 4 = 380
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 8360 + 380 = 8740
# sll  $t1, $a0, 1         # $t1 = $a0 << 1 = 95 * 2 = 190
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 8740 + 190 = 8930
# add  $t0, $t0, $a0       # $t0 = $t0 + $a0 = 8930 + 95 = 9025
# sw   $t0, 0($s0)         # Store result at current address
# addi $s0, $s0, 4         # Move to next memory location

# # Square of 96 = 9216
# addi $a0, $zero, 96      # Set $a0 = 96
# sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 96 * 64 = 6144
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 96 * 32 = 3072
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 6144 - 3072 = 3072
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 96 * 32 = 3072
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 3072 + 3072 = 6144
# sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 96 * 16 = 1536
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 6144 - 1536 = 4608
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 96 * 8 = 768
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4608 + 768 = 5376
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 96 * 8 = 768
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5376 + 768 = 6144
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 96 * 8 = 768
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6144 + 768 = 6912
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 96 * 8 = 768
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6912 + 768 = 7680
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 96 * 8 = 768
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 7680 + 768 = 8448
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 96 * 8 = 768
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 8448 + 768 = 9216
# sw   $t0, 0($s0)         # Store result at current address
# addi $s0, $s0, 4         # Move to next memory location

# # Square of 97 = 9409
# addi $a0, $zero, 97      # Set $a0 = 97
# sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 97 * 64 = 6208
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 97 * 32 = 3104
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 6208 - 3104 = 3104
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 97 * 32 = 3104
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 3104 + 3104 = 6208
# sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 97 * 16 = 1552
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 6208 - 1552 = 4656
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 97 * 8 = 776
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4656 + 776 = 5432
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 97 * 8 = 776
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5432 + 776 = 6208
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 97 * 8 = 776
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6208 + 776 = 6984
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 97 * 8 = 776
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6984 + 776 = 7760
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 97 * 8 = 776
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 7760 + 776 = 8536
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 97 * 8 = 776
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 8536 + 776 = 9312
# add  $t0, $t0, $a0       # $t0 = $t0 + $a0 = 9312 + 97 = 9409
# sw   $t0, 0($s0)         # Store result at current address
# addi $s0, $s0, 4         # Move to next memory location

# # Square of 98 = 9604
# addi $a0, $zero, 98      # Set $a0 = 98
# sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 98 * 64 = 6272
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 98 * 32 = 3136
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 6272 - 3136 = 3136
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 98 * 32 = 3136
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 3136 + 3136 = 6272
# sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 98 * 16 = 1568
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 6272 - 1568 = 4704
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 98 * 8 = 784
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4704 + 784 = 5488
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 98 * 8 = 784
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5488 + 784 = 6272
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 98 * 8 = 784
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6272 + 784 = 7056
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 98 * 8 = 784
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 7056 + 784 = 7840
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 98 * 8 = 784
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 7840 + 784 = 8624
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 98 * 8 = 784
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 8624 + 784 = 9408
# sll  $t1, $a0, 1         # $t1 = $a0 << 1 = 98 * 2 = 196
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 9408 + 196 = 9604
# sw   $t0, 0($s0)         # Store result at current address
# addi $s0, $s0, 4         # Move to next memory location

# # Square of 99 = 9801
# addi $a0, $zero, 99      # Set $a0 = 99
# sll  $t0, $a0, 6         # $t0 = $a0 << 6 = 99 * 64 = 6336
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 99 * 32 = 3168
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 6336 - 3168 = 3168
# sll  $t1, $a0, 5         # $t1 = $a0 << 5 = 99 * 32 = 3168
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 3168 + 3168 = 6336
# sll  $t1, $a0, 4         # $t1 = $a0 << 4 = 99 * 16 = 1584
# sub  $t0, $t0, $t1       # $t0 = $t0 - $t1 = 6336 - 1584 = 4752
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 99 * 8 = 792
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 4752 + 792 = 5544
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 99 * 8 = 792
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 5544 + 792 = 6336
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 99 * 8 = 792
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 6336 + 792 = 7128
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 99 * 8 = 792
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 7128 + 792 = 7920
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 99 * 8 = 792
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 7920 + 792 = 8712
# sll  $t1, $a0, 3         # $t1 = $a0 << 3 = 99 * 8 = 792
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 8712 + 792 = 9504
# sll  $t1, $a0, 2         # $t1 = $a0 << 2 = 99 * 4 = 396
# add  $t0, $t0, $t1       # $t0 = $t0 + $t1 = 9504 + 396 = 9900
# add  $t0, $t0, $a0       # $t0 = $t0 + $a0 = 9900 + 99 = 9999
# sw   $t0, 0($s0)         # Store result at current address
# addi $s0, $s0, 4         # Move to next memory location

# # Square of 100 = 10000
# addi $a0, $zero, 100     # Set $a0 = 100
# sll $t0, $a0, 6          # $t0 = $a0 << 6 = 100 * 64 = 6400
# sll $t1, $a0, 5          # $t1 = $a0 << 5 = 100 * 32 = 3200
# add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 6400 + 3200 = 9600
# sll $t1, $a0, 2          # $t1 = $a0 << 2 = 100 * 4 = 400
# add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 9600 + 400 = 10000
# sw $t0, 0($s0)           # Store result at current address
# addi $s0, $s0, 4         # Move to next memory location

# # Square of 150 = 22500
# addi $a0, $zero, 150     # Set $a0 = 150
# sll $t0, $a0, 7          # $t0 = $a0 << 7 = 150 * 128 = 19200
# sll $t1, $a0, 5          # $t1 = $a0 << 5 = 150 * 32 = 4800
# sub $t2, $t0, $t1        # $t2 = $t0 - $t1 = 19200 - 4800 = 14400
# sll $t0, $a0, 6          # $t0 = $a0 << 6 = 150 * 64 = 9600
# sub $t1, $t0, $a0        # $t1 = $t0 - $a0 = 9600 - 150 = 9450
# sub $t1, $t1, $a0        # $t1 = $t1 - $a0 = 9450 - 150 = 9300
# sub $t1, $t1, $a0        # $t1 = $t1 - $a0 = 9300 - 150 = 9150
# sub $t1, $t1, $a0        # $t1 = $t1 - $a0 = 9150 - 150 = 9000
# sub $t0, $t2, $t1        # $t0 = $t2 - $t1 = 14400 - 9000 = 5400
# sll $t1, $a0, 8          # $t1 = $a0 << 8 = 150 * 256 = 38400
# sub $t1, $t1, $t0        # $t1 = $t1 - $t0 = 38400 - 5400 = 33000
# sub $t0, $t1, $t2        # $t0 = $t1 - $t2 = 33000 - 14400 = 18600
# add $t0, $t0, $t2        # $t0 = $t0 + $t2 = 18600 + 14400 = 33000
# sll $t1, $a0, 3          # $t1 = $a0 << 3 = 150 * 8 = 1200
# sub $t2, $t0, $t1        # $t2 = $t0 - $t1 = 33000 - 1200 = 31800
# sll $t1, $a0, 4          # $t1 = $a0 << 4 = 150 * 16 = 2400
# sub $t0, $t2, $t1        # $t0 = $t2 - $t1 = 31800 - 2400 = 29400
# sll $t1, $a0, 6          # $t1 = $a0 << 6 = 150 * 64 = 9600
# sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 29400 - 9600 = 19800
# add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 19800 + 150 = 19950
# add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 19950 + 150 = 20100
# add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 20100 + 150 = 20250
# add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 20250 + 150 = 20400
# add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 20400 + 150 = 20550
# add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 20550 + 150 = 20700
# add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 20700 + 150 = 20850
# add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 20850 + 150 = 21000
# add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 21000 + 150 = 21150
# add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 21150 + 150 = 21300
# add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 21300 + 150 = 21450
# add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 21450 + 150 = 21600
# add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 21600 + 150 = 21750
# add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 21750 + 150 = 21900
# add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 21900 + 150 = 22050
# add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 22050 + 150 = 22200
# add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 22200 + 150 = 22350
# add $t0, $t0, $a0        # $t0 = $t0 + $a0 = 22350 + 150 = 22500
# sw $t0, 0($s0)           # Store result at current address
# addi $s0, $s0, 4         # Move to next memory location

# # Square of 151 = 22801
# addi $a0, $zero, 151      # Set $a0 = 151
# sll $t0, $a0, 7           # $t0 = $a0 << 7 = 151 * 128 = 19328
# sll $t1, $a0, 5           # $t1 = $a0 << 5 = 151 * 32 = 4832
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 19328 + 4832 = 24160
# sll $t1, $a0, 4           # $t1 = $a0 << 4 = 151 * 16 = 2416
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 24160 - 2416 = 21744
# sll $t1, $a0, 3           # $t1 = $a0 << 3 = 151 * 8 = 1208
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 21744 + 1208 = 22952
# sll $t1, $a0, 1           # $t1 = $a0 << 1 = 151 * 2 = 302
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 22952 - 302 = 22650
# add $t0, $t0, $a0         # $t0 = $t0 + $a0 = 22650 + 151 = 22801
# sw $t0, 0($s0)            # Store result at current address
# addi $s0, $s0, 4          # Move to next memory location

# # Square of 152 = 23104
# addi $a0, $zero, 152      # Set $a0 = 152
# sll $t0, $a0, 7           # $t0 = $a0 << 7 = 152 * 128 = 19456
# sll $t1, $a0, 5           # $t1 = $a0 << 5 = 152 * 32 = 4864
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 19456 + 4864 = 24320
# sll $t1, $a0, 4           # $t1 = $a0 << 4 = 152 * 16 = 2432
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 24320 - 2432 = 21888
# sll $t1, $a0, 3           # $t1 = $a0 << 3 = 152 * 8 = 1216
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 21888 + 1216 = 23104
# sw $t0, 0($s0)            # Store result at current address
# addi $s0, $s0, 4          # Move to next memory location

# # Square of 153 = 23409
# addi $a0, $zero, 153      # Set $a0 = 153
# sll $t0, $a0, 7           # $t0 = $a0 << 7 = 153 * 128 = 19584
# sll $t1, $a0, 5           # $t1 = $a0 << 5 = 153 * 32 = 4896
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 19584 + 4896 = 24480
# sll $t1, $a0, 4           # $t1 = $a0 << 4 = 153 * 16 = 2448
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 24480 - 2448 = 22032
# sll $t1, $a0, 3           # $t1 = $a0 << 3 = 153 * 8 = 1224
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 22032 + 1224 = 23256
# add $t0, $t0, $a0         # $t0 = $t0 + $a0 = 23256 + 153 = 23409
# sw $t0, 0($s0)            # Store result at current address
# addi $s0, $s0, 4          # Move to next memory location

# # Square of 154 = 23716
# addi $a0, $zero, 154      # Set $a0 = 154
# sll $t0, $a0, 7           # $t0 = $a0 << 7 = 154 * 128 = 19712
# sll $t1, $a0, 5           # $t1 = $a0 << 5 = 154 * 32 = 4928
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 19712 + 4928 = 24640
# sll $t1, $a0, 4           # $t1 = $a0 << 4 = 154 * 16 = 2464
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 24640 - 2464 = 22176
# sll $t1, $a0, 3           # $t1 = $a0 << 3 = 154 * 8 = 1232
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 22176 + 1232 = 23408
# sll $t1, $a0, 1           # $t1 = $a0 << 1 = 154 * 2 = 308
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 23408 + 308 = 23716
# sw $t0, 0($s0)            # Store result at current address
# addi $s0, $s0, 4          # Move to next memory location

# # Square of 155 = 24025
# addi $a0, $zero, 155      # Set $a0 = 155
# sll $t0, $a0, 7           # $t0 = $a0 << 7 = 155 * 128 = 19840
# sll $t1, $a0, 5           # $t1 = $a0 << 5 = 155 * 32 = 4960
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 19840 + 4960 = 24800
# sll $t1, $a0, 4           # $t1 = $a0 << 4 = 155 * 16 = 2480
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 24800 - 2480 = 22320
# sll $t1, $a0, 3           # $t1 = $a0 << 3 = 155 * 8 = 1240
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 22320 + 1240 = 23560
# sll $t1, $a0, 2           # $t1 = $a0 << 2 = 155 * 4 = 620
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 23560 + 620 = 24180
# sll $t1, $a0, 1           # $t1 = $a0 << 1 = 155 * 2 = 310
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 24180 - 310 = 23870
# add $t0, $t0, $a0         # $t0 = $t0 + $a0 = 23870 + 155 = 24025
# sw $t0, 0($s0)            # Store result at current address
# addi $s0, $s0, 4          # Move to next memory location

# # Square of 156 = 24336
# addi $a0, $zero, 156      # Set $a0 = 156
# sll $t0, $a0, 7           # $t0 = $a0 << 7 = 156 * 128 = 19968
# sll $t1, $a0, 5           # $t1 = $a0 << 5 = 156 * 32 = 4992
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 19968 + 4992 = 24960
# sll $t1, $a0, 4           # $t1 = $a0 << 4 = 156 * 16 = 2496
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 24960 - 2496 = 22464
# sll $t1, $a0, 3           # $t1 = $a0 << 3 = 156 * 8 = 1248
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 22464 + 1248 = 23712
# sll $t1, $a0, 2           # $t1 = $a0 << 2 = 156 * 4 = 624
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 23712 + 624 = 24336
# sw $t0, 0($s0)            # Store result at current address
# addi $s0, $s0, 4          # Move to next memory location

# # Square of 157 = 24649
# addi $a0, $zero, 157      # Set $a0 = 157
# sll $t0, $a0, 7           # $t0 = $a0 << 7 = 157 * 128 = 20096
# sll $t1, $a0, 5           # $t1 = $a0 << 5 = 157 * 32 = 5024
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 20096 + 5024 = 25120
# sll $t1, $a0, 4           # $t1 = $a0 << 4 = 157 * 16 = 2512
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 25120 - 2512 = 22608
# sll $t1, $a0, 3           # $t1 = $a0 << 3 = 157 * 8 = 1256
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 22608 + 1256 = 23864
# sll $t1, $a0, 2           # $t1 = $a0 << 2 = 157 * 4 = 628
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 23864 + 628 = 24492
# add $t0, $t0, $a0         # $t0 = $t0 + $a0 = 24492 + 157 = 24649
# sw $t0, 0($s0)            # Store result at current address
# addi $s0, $s0, 4          # Move to next memory location

# # Square of 158 = 24964
# addi $a0, $zero, 158      # Set $a0 = 158
# sll $t0, $a0, 7           # $t0 = $a0 << 7 = 158 * 128 = 20224
# sll $t1, $a0, 5           # $t1 = $a0 << 5 = 158 * 32 = 5056
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 20224 + 5056 = 25280
# sll $t1, $a0, 4           # $t1 = $a0 << 4 = 158 * 16 = 2528
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 25280 - 2528 = 22752
# sll $t1, $a0, 3           # $t1 = $a0 << 3 = 158 * 8 = 1264
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 22752 + 1264 = 24016
# sll $t1, $a0, 2           # $t1 = $a0 << 2 = 158 * 4 = 632
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 24016 + 632 = 24648
# sll $t1, $a0, 1           # $t1 = $a0 << 1 = 158 * 2 = 316
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 24648 + 316 = 24964
# sw $t0, 0($s0)            # Store result at current address
# addi $s0, $s0, 4          # Move to next memory location

# # Square of 159 = 25281
# addi $a0, $zero, 159      # Set $a0 = 159
# sll $t0, $a0, 7           # $t0 = $a0 << 7 = 159 * 128 = 20352
# sll $t1, $a0, 5           # $t1 = $a0 << 5 = 159 * 32 = 5088
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 20352 + 5088 = 25440
# sll $t1, $a0, 4           # $t1 = $a0 << 4 = 159 * 16 = 2544
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 25440 - 2544 = 22896
# sll $t1, $a0, 3           # $t1 = $a0 << 3 = 159 * 8 = 1272
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 22896 + 1272 = 24168
# sll $t1, $a0, 2           # $t1 = $a0 << 2 = 159 * 4 = 636
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 24168 + 636 = 24804
# sll $t1, $a0, 1           # $t1 = $a0 << 1 = 159 * 2 = 318
# add $t0, $t0, $t1         # $t0 = $t0 + $t1 = 24804 + 318 = 25122
# add $t0, $t0, $a0         # $t0 = $t0 + $a0 = 25122 + 159 = 25281
# sw $t0, 0($s0)            # Store result at current address
# addi $s0, $s0, 4          # Move to next memory location

# # Square of 160 = 25600
# addi $a0, $zero, 160      # Set $a0 = 160
# sll $t0, $a0, 8           # $t0 = $a0 << 8 = 160 * 256 = 40960
# sll $t1, $a0, 6           # $t1 = $a0 << 6 = 160 * 64 = 10240
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 40960 - 10240 = 30720
# sll $t1, $a0, 4           # $t1 = $a0 << 4 = 160 * 16 = 2560
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 30720 - 2560 = 28160
# sll $t1, $a0, 3           # $t1 = $a0 << 3 = 160 * 8 = 1280
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 28160 - 1280 = 26880
# sll $t1, $a0, 2           # $t1 = $a0 << 2 = 160 * 4 = 640
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 26880 - 640 = 26240
# sll $t1, $a0, 1           # $t1 = $a0 << 1 = 160 * 2 = 320
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 26240 - 320 = 25920
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 25920 - 160 = 25760
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 25760 - 160 = 25600
# sw $t0, 0($s0)            # Store result at current address
# addi $s0, $s0, 4          # Move to next memory location

# # Square of 161 = 25921
# addi $a0, $zero, 161      # Set $a0 = 161
# sll $t0, $a0, 8           # $t0 = $a0 << 8 = 161 * 256 = 41216
# sll $t1, $a0, 6           # $t1 = $a0 << 6 = 161 * 64 = 10304
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 41216 - 10304 = 30912
# sll $t1, $a0, 4           # $t1 = $a0 << 4 = 161 * 16 = 2576
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 30912 - 2576 = 28336
# sll $t1, $a0, 3           # $t1 = $a0 << 3 = 161 * 8 = 1288
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 28336 - 1288 = 27048
# sll $t1, $a0, 2           # $t1 = $a0 << 2 = 161 * 4 = 644
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 27048 - 644 = 26404
# sll $t1, $a0, 1           # $t1 = $a0 << 1 = 161 * 2 = 322
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 26404 - 322 = 26082
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 26082 - 161 = 25921
# sw $t0, 0($s0)            # Store result at current address
# addi $s0, $s0, 4          # Move to next memory location

# # Square of 162 = 26244
# addi $a0, $zero, 162      # Set $a0 = 162
# sll $t0, $a0, 8           # $t0 = $a0 << 8 = 162 * 256 = 41472
# sll $t1, $a0, 5           # $t1 = $a0 << 5 = 162 * 32 = 5184
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 41472 - 5184 = 36288
# sll $t1, $a0, 4           # $t1 = $a0 << 4 = 162 * 16 = 2592
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 36288 - 2592 = 33696
# sll $t1, $a0, 3           # $t1 = $a0 << 3 = 162 * 8 = 1296
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 33696 - 1296 = 32400
# sll $t1, $a0, 2           # $t1 = $a0 << 2 = 162 * 4 = 648
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 32400 - 648 = 31752
# sll $t1, $a0, 1           # $t1 = $a0 << 1 = 162 * 2 = 324
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 31752 - 324 = 31428
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 31428 - 162 = 31266
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 31266 - 162 = 31104
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 31104 - 162 = 30942
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 30942 - 162 = 30780
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 30780 - 162 = 30618
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 30618 - 162 = 30456
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 30456 - 162 = 30294
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 30294 - 162 = 30132
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 30132 - 162 = 29970
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 29970 - 162 = 29808
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 29808 - 162 = 29646
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 29646 - 162 = 29484
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 29484 - 162 = 29322
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 29322 - 162 = 29160
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 29160 - 162 = 28998
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 28998 - 162 = 28836
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 28836 - 162 = 28674
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 28674 - 162 = 28512
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 28512 - 162 = 28350
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 28350 - 162 = 28188
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 28188 - 162 = 28026
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 28026 - 162 = 27864
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 27864 - 162 = 27702
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 27702 - 162 = 27540
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 27540 - 162 = 27378
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 27378 - 162 = 27216
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 27216 - 162 = 27054
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 27054 - 162 = 26892
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 26892 - 162 = 26730
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 26730 - 162 = 26568
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 26568 - 162 = 26406
# sub $t0, $t0, $a0         # $t0 = $t0 - $a0 = 26406 - 162 = 26244
# sw $t0, 0($s0)            # Store result at current address
# addi $s0, $s0, 4          # Move to next memory location

# # Square of 163 = 26569
# addi $a0, $zero, 163      # Set $a0 = 163
# sll $t0, $a0, 8           # $t0 = $a0 << 8 = 163 * 256 = 41728
# sll $t1, $a0, 6           # $t1 = $a0 << 6 = 163 * 64 = 10432
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 41728 - 10432 = 31296
# sll $t1, $a0, 4           # $t1 = $a0 << 4 = 163 * 16 = 2608
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 31296 - 2608 = 28688
# sll $t1, $a0, 3           # $t1 = $a0 << 3 = 163 * 8 = 1304
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 28688 - 1304 = 27384
# sll $t1, $a0, 2           # $t1 = $a0 << 2 = 163 * 4 = 652
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 27384 - 652 = 26732
# sll $t1, $a0, 1           # $t1 = $a0 << 1 = 163 * 2 = 326
# sub $t0, $t0, $t1         # $t0 = $t0 - $t1 = 26732 - 326 = 26406
# add $t0, $t0, $a0         # $t0 = $t0 + $a0 = 26406 + 163 = 26569
# sw $t0, 0($s0)            # Store result at current address
# addi $s0, $s0, 4          # Move to next memory location
# ######164 - 199#######
# # Square of 200 = 40000
# addi $a0, $zero, 200     # Set $a0 = 200
# sll $t0, $a0, 8          # $t0 = $a0 << 8 = 200 * 256 = 51200
# sll $t1, $a0, 7          # $t1 = $a0 << 7 = 200 * 128 = 25600
# sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 51200 - 25600 = 25600
# sll $t1, $a0, 6          # $t1 = $a0 << 6 = 200 * 64 = 12800
# add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 25600 + 12800 = 38400
# sll $t1, $a0, 4          # $t1 = $a0 << 4 = 200 * 16 = 3200
# sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 38400 - 3200 = 35200
# sll $t1, $a0, 3          # $t1 = $a0 << 3 = 200 * 8 = 1600
# add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 35200 + 1600 = 36800
# sll $t1, $a0, 5          # $t1 = $a0 << 5 = 200 * 32 = 6400
# add $t0, $t0, $t1        # $t0 = $t0 + $t1 = 36800 + 6400 = 43200
# sll $t1, $a0, 2          # $t1 = $a0 << 2 = 200 * 4 = 800
# sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 43200 - 800 = 42400
# sll $t1, $a0, 1          # $t1 = $a0 << 1 = 200 * 2 = 400
# sub $t0, $t0, $t1        # $t0 = $t0 - $t1 = 42400 - 400 = 42000
# sub $t0, $t0, $a0        # $t0 = $t0 - $a0 = 42000 - 200 = 41800
# sub $t0, $t0, $a0        # $t0 = $t0 - $a0 = 41800 - 200 = 41600
# sub $t0, $t0, $a0        # $t0 = $t0 - $a0 = 41600 - 200 = 41400
# sub $t0, $t0, $a0        # $t0 = $t0 - $a0 = 41400 - 200 = 41200
# sub $t0, $t0, $a0        # $t0 = $t0 - $a0 = 41200 - 200 = 41000
# sub $t0, $t0, $a0        # $t0 = $t0 - $a0 = 41000 - 200 = 40800
# sub $t0, $t0, $a0        # $t0 = $t0 - $a0 = 40800 - 200 = 40600
# sub $t0, $t0, $a0        # $t0 = $t0 - $a0 = 40600 - 200 = 40400
# sub $t0, $t0, $a0        # $t0 = $t0 - $a0 = 40400 - 200 = 40200
# sub $t0, $t0, $a0        # $t0 = $t0 - $a0 = 40200 - 200 = 40000
# sw $t0, 0($s0)           # Store result at current address
# addi $s0, $s0, 4         # Move to next memory location