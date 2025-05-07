from instruction_set import INSTRUCTION_SET

def parse_instruction(instruction):
    """
    Parses a single instruction and returns its components.
    Args:
        instruction (str): The instruction to parse.
    Returns:
        tuple: A tuple containing the opcode, the type of instruction, and the operands.
    """
    # Handle string or integer instruction
    if not isinstance(instruction, str):
        return None
        
    # Strip comments and empty lines
    instruction = instruction.split('#')[0].strip()
    if not instruction:
        return None
        
    # Split the instruction into parts
    parts = instruction.replace(',','').split()
    
    # Get the opcode
    opcode = parts[0]
    
    # Check if the opcode is valid
    if opcode not in INSTRUCTION_SET:
        raise ValueError(f"Invalid opcode: {opcode}")
        
    # Get the type and format of the instruction
    instr_type = INSTRUCTION_SET[opcode]['type']
    instr_format = INSTRUCTION_SET[opcode]['format']
    
    # Parse the operands based on the format
    operands = {}
    
    # Special handling for memory operations (lw, sw)
    if opcode in ["lw", "sw"] and len(parts) >= 3:
        operands["rt"] = parts[1]
        
        # Parse the address part (e.g., "0($t4)")
        addr_part = parts[2]
        operands["imm(rs)"] = addr_part
        
        # Try to extract immediate and register parts
        if "(" in addr_part and ")" in addr_part:
            imm_part = addr_part.split("(")[0].strip()
            reg_part = addr_part.split("(")[1].rstrip(")").strip()
            
            if imm_part:
                operands["imm"] = imm_part
            operands["rs"] = reg_part
    else:
        # Standard parsing for other instructions
        for i, operand in enumerate(parts[1:]):
            if i < len(instr_format):
                field_name = instr_format[i]
                operands[field_name] = operand
            else:
                raise ValueError(f"Too many operands for {opcode}: {instruction}")
                
    return opcode, instr_type, operands