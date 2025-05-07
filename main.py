#!/usr/bin/env python3
import argparse
from simulator import Simulator
from instruction_parser import parse_instruction

def load_assembly_program(file_path):
    """
    Load MIPS assembly program from a file.
    
    Args:
        file_path (str): Path to the assembly file
        
    Returns:
        list: List of (address, instruction) tuples
    """
    from memory import Memory  # Import to access memory constants
    
    program = []
    address = Memory.INSTR_START  # Start at the beginning of instruction memory
    
    with open(file_path, 'r') as f:
        for line in f:
            # Remove comments and strip whitespace
            line = line.split('#')[0].strip()
            if line:
                # Store at current address
                program.append((address, line))
                address += 4  # Instructions are word-aligned
                
                # Check if we've exceeded instruction memory
                if address > Memory.INSTR_END:
                    print(f"Warning: Program exceeds instruction memory limit at {hex(address)}")
                    # We could either wrap around or truncate here
                    # For safety, we'll truncate
                    break
                
    return program

def parse_initial_data(file_path):
    """
    Parse initial data memory values from a file.
    
    Args:
        file_path (str): Path to the data file
        
    Returns:
        list: List of (address, value) tuples
    """
    from memory import Memory  # Import to access memory constants
    
    data = []
    
    with open(file_path, 'r') as f:
        for line in f:
            # Remove comments and strip whitespace
            line = line.split('#')[0].strip()
            if line:
                # Parse address and value (format: address:value)
                parts = line.split(':')
                if len(parts) == 2:
                    try:
                        # Try to parse as hex if it starts with 0x
                        if parts[0].strip().lower().startswith("0x"):
                            address = int(parts[0].strip(), 16)
                        else:
                            address = int(parts[0].strip())
                            
                        # Similarly for value
                        if parts[1].strip().lower().startswith("0x"):
                            value = int(parts[1].strip(), 16)
                        else:
                            value = int(parts[1].strip())
                            
                        # Check if address is in data memory range
                        if not (Memory.DATA_START <= address <= Memory.DATA_END):
                            adjusted_address = Memory.DATA_START + (address % (Memory.DATA_END - Memory.DATA_START + 1))
                            print(f"Warning: Address {hex(address)} is outside data memory. "
                                f"Adjusted to {hex(adjusted_address)}.")
                            address = adjusted_address
                            
                        data.append((address, value))
                    except ValueError:
                        print(f"Warning: Invalid data format: {line}")
                        
    return data

def main():
    parser = argparse.ArgumentParser(description='MIPS Pipeline Simulator')
    parser.add_argument('program', help='Path to the MIPS assembly program file')
    parser.add_argument('--data', help='Path to the initial data memory file')
    parser.add_argument('--cycles', type=int, default=1000, help='Maximum number of cycles to simulate')
    parser.add_argument('--verbose', action='store_true', help='Print detailed cycle-by-cycle logs')
    
    args = parser.parse_args()
    
    # Load program
    try:
        program = load_assembly_program(args.program)
    except FileNotFoundError:
        print(f"Error: Program file not found: {args.program}")
        return
        
    # Load data if provided
    data = None
    if args.data:
        try:
            data = parse_initial_data(args.data)
        except FileNotFoundError:
            print(f"Error: Data file not found: {args.data}")
            return
            
    # Create and run simulator
    simulator = Simulator(program, data, args.cycles)
    cycles = simulator.run(args.verbose)
    
    print(f"\nSimulation completed in {cycles} cycles")

if __name__ == "__main__":
    main()