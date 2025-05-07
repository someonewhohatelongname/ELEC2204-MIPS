#!/usr/bin/env python3
import argparse
from simulator import Simulator
from instruction_parser import parse_instruction
from memory import Memory

def load_assembly_program(file_path):
    """
    Load MIPS assembly program from a file.
    
    Args:
        file_path (str): Path to the assembly file
        
    Returns:
        list: List of (address, instruction) tuples
    """
    program = []
    address = Memory.TEXT_START  # Start at the beginning of text segment
    
    with open(file_path, 'r') as f:
        for line in f:
            # Remove comments and strip whitespace
            line = line.split('#')[0].strip()
            if line:
                # Store at current address
                program.append((address, line))
                address += 4  # Instructions are word-aligned
                
                # Check if we've exceeded text segment
                if address > Memory.TEXT_END:
                    print(f"Warning: Program exceeds text segment limit at {hex(address)}")
                    # We could either wrap around or truncate here
                    # For safety, we'll truncate
                    break
                
    return program

def parse_initial_data(file_path, segment_type="static"):
    """
    Parse initial data memory values from a file.
    
    Args:
        file_path (str): Path to the data file
        segment_type (str): Which segment to load the data into ("static", "dynamic", or "stack")
        
    Returns:
        list: List of (address, value) tuples
    """
    data = []
    
    # Determine the segment range
    if segment_type == "static":
        segment_start = Memory.STATIC_START
        segment_end = Memory.STATIC_END
    elif segment_type == "dynamic":
        segment_start = Memory.DYNAMIC_START
        segment_end = Memory.DYNAMIC_END
    elif segment_type == "stack":
        segment_start = Memory.STACK_START
        segment_end = Memory.STACK_END
    else:
        print(f"Warning: Unknown segment type '{segment_type}'. Using static segment.")
        segment_start = Memory.STATIC_START
        segment_end = Memory.STATIC_END
    
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
                            
                        # Check if address is in the specified segment range
                        if not (segment_start <= address <= segment_end):
                            adjusted_address = segment_start + (address % (segment_end - segment_start + 1))
                            print(f"Warning: Address {hex(address)} is outside {segment_type} segment. "
                                f"Adjusted to {hex(adjusted_address)}.")
                            address = adjusted_address
                            
                        data.append((address, value))
                    except ValueError:
                        print(f"Warning: Invalid data format: {line}")
                        
    return data

def main():
    parser = argparse.ArgumentParser(description='MIPS Pipeline Simulator')
    parser.add_argument('program', help='Path to the MIPS assembly program file')
    parser.add_argument('--static-data', help='Path to the static data segment initialization file')
    parser.add_argument('--dynamic-data', help='Path to the dynamic (heap) data segment initialization file')
    parser.add_argument('--stack-data', help='Path to the stack segment initialization file')
    parser.add_argument('--stack-pointer', type=int, help='Initial stack pointer value (defaults to top of stack)')
    parser.add_argument('--cycles', type=int, default=1000, help='Maximum number of cycles to simulate')
    parser.add_argument('--verbose', action='store_true', help='Print detailed cycle-by-cycle logs')
    
    args = parser.parse_args()
    
    # Load program
    try:
        program = load_assembly_program(args.program)
    except FileNotFoundError:
        print(f"Error: Program file not found: {args.program}")
        return
        
    # Load static data if provided
    static_data = []
    if args.static_data:
        try:
            static_data = parse_initial_data(args.static_data, "static")
        except FileNotFoundError:
            print(f"Error: Static data file not found: {args.static_data}")
            return
    
    # Load dynamic data if provided
    dynamic_data = []
    if args.dynamic_data:
        try:
            dynamic_data = parse_initial_data(args.dynamic_data, "dynamic")
        except FileNotFoundError:
            print(f"Error: Dynamic data file not found: {args.dynamic_data}")
            return
    
    # Load stack data if provided
    stack_data = []
    if args.stack_data:
        try:
            stack_data = parse_initial_data(args.stack_data, "stack")
        except FileNotFoundError:
            print(f"Error: Stack data file not found: {args.stack_data}")
            return
    
    # Combine all data
    all_data = static_data + dynamic_data + stack_data
    
    # Create and run simulator
    simulator = Simulator(program, all_data, args.cycles, args.stack_pointer)
    cycles = simulator.run(args.verbose)
    
    print(f"\nSimulation completed in {cycles} cycles")

if __name__ == "__main__":
    main()